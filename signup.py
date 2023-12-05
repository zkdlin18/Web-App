from flask import Flask, render_template, request, redirect, url_for, session, flash
from flask_mysqldb import MySQL
from flask_mysqldb import MySQLdb
from datetime import datetime 
from flask import jsonify


app = Flask(__name__)
app.secret_key = '123'
# Configure the database connection
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'webapp_db'

mysql = MySQL(app)


def format_timestamp(timestamp):
    # If timestamp is a string, convert it to datetime object
    if isinstance(timestamp, str):
        timestamp = datetime.strptime(timestamp, '%Y-%m-%d %H:%M:%S')

    # Format the timestamp in the desired format
    return timestamp.strftime('%B %d, %Y %I:%M %p')


@app.route('/signup', methods=['GET', 'POST'])
def signup_form():
    if request.method == 'POST':
        # Get form data
        username = request.form['username']
        password = request.form['password']

        # Check if the username already exists
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM users WHERE username = %s", (username,))
        existing_user = cur.fetchone()
        cur.close()

        if existing_user:
            error = 'Username already exists.'
            return render_template('signup.html', error=error)


        # Insert the new user into the database
        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO users (username, password) VALUES (%s, %s)", (username, password))
        mysql.connection.commit()
        cur.close()
        error = 'Account created successfully!'
        return render_template('signup.html', message='Account created successfully!')
    else:
        return render_template('signup.html')
@app.route('/')
def login_form():
    return render_template('index.html')

@app.route('/login', methods=['POST'])
def login():
    # Get form data
    username = request.form['username']
    password = request.form['password']

    # Connect to the database
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    # Check if the username and password match
    cur.execute("SELECT * FROM users WHERE username = %s AND password = %s", (username, password))
    user = cur.fetchone()

    if user:
        session['user_id'] = user['user_id']
        return redirect(url_for('home_page'))  # Redirect to home_page instead of rendering home.html directly
    else:
        error = 'Invalid credentials. Please try again.'
        return render_template('index.html', error=error)
@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        # Get form data
        username = request.form['username']
        password = request.form['password']

        # Check if the username already exists
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM users WHERE username = %s", (username,))
        existing_user = cur.fetchone()
        cur.close()

        if existing_user:
            error = 'Username already exists!'
            return render_template('signup.html', error=error)

        try:
            # Insert the new user into the database
            cur = mysql.connection.cursor()
            cur.execute("INSERT INTO users (username, password) VALUES (%s, %s)", (username, password))
            mysql.connection.commit()
            cur.close()

            # Render the template with a success message
            message = 'Account created successfully!'
            return render_template('signup.html', message=message)

        except Exception as e:
            # Handle other exceptions
            error = f'Signup failed. {str(e)}'
            return render_template('signup.html', error=error)

    # If it's a GET request, simply render the signup form
    return render_template('signup.html')

@app.route('/home')
def home_page():
    # Retrieve all posts with usernames
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("""
        SELECT posts.*, users.username
        FROM posts
        LEFT JOIN users ON posts.user_id = users.user_id
        ORDER BY posts.created_at DESC
    """)
    all_posts = cur.fetchall()
    cur.close()

    # Retrieve all users for the chat dropdown
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("SELECT * FROM users")
    all_users = cur.fetchall()
    cur.close()

    return render_template('home.html', all_posts=all_posts, all_users=all_users)
@app.route('/post', methods=['POST'])
def create_post():
    # Check if the user is logged in
    user_id = session.get('user_id')
    if not user_id:
        return redirect(url_for('login_form'))

    # Get form data
    post_content = request.form['postContent']

    # Save the post to the database
    cur = mysql.connection.cursor()
    cur.execute("INSERT INTO posts (user_id, content) VALUES (%s, %s)", (user_id, post_content))
    mysql.connection.commit()  # Commit the transaction
    cur.close()

    # Redirect to the home page
    return redirect(url_for('home_page'))

@app.route('/delete_post/<int:post_id>', methods=['POST'])
def delete_post(post_id):
    if 'user_id' not in session:
        return redirect(url_for('login_form'))

    user_id = session['user_id']

    # Check if the logged-in user is the owner of the post
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM posts WHERE post_id = %s AND user_id = %s", (post_id, user_id))
    post = cur.fetchone()
    cur.close()

    if not post:
        return redirect(url_for('home_page'))

    # Delete the post
    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM posts WHERE post_id = %s", (post_id,))
    mysql.connection.commit()
    cur.close()

    return redirect(url_for('home_page'))

@app.route('/logout')
def logout():
    # Clear the user_id from the session, effectively logging the user out
    session.pop('user_id', None)
    return redirect(url_for('login_form'))

@app.route('/chat/send_message', methods=['POST'])
def send_message():
    if 'user_id' not in session:
        return jsonify({'success': False, 'error': 'User not logged in'})

    sender_user_id = session['user_id']
    receiver_username = request.form['receiver_username']
    message_content = request.form['message_content']

    # Retrieve the sender's username from the users table
    cur = mysql.connection.cursor()
    cur.execute("SELECT username FROM users WHERE user_id = %s", (sender_user_id,))
    result = cur.fetchone()

    if result:
        sender_username = result[0]
    else:
        cur.close()
        return jsonify({'success': False, 'error': 'User not found'})

    cur.close()

    # Save the message to the database
    cur = mysql.connection.cursor()
    cur.execute("""
    INSERT INTO messages (sender_id, receiver_username, content, sender_username)
    VALUES (%s, %s, %s, %s)
    """, (sender_user_id, receiver_username, message_content, sender_username))

    mysql.connection.commit()
    cur.close()

    return jsonify({'success': True})


@app.route('/chat/get_messages', methods=['GET'])
def get_messages():
    if 'user_id' not in session:
        return jsonify({'success': False, 'error': 'User not logged in'})

    user_id = session['user_id']
    receiver_username = request.args.get('receiver_username')

    # Retrieve messages from the database (you need to have a messages table)
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("""
    SELECT sender.username as sender_username, receiver.username as receiver_username,
           content, created_at
    FROM messages
    LEFT JOIN users as sender ON messages.sender_id = sender.user_id
    LEFT JOIN users as receiver ON messages.receiver_username = receiver.username
    WHERE (sender.user_id = %s AND receiver.username = %s)
        OR (sender.username = %s AND receiver.user_id = %s)
    ORDER BY created_at
    """, (user_id, receiver_username, receiver_username, user_id))

    messages = cur.fetchall()
    cur.close()

    # Format the messages and send the response
    formatted_messages = [
        {
            'sender_username': message['sender_username'],
            'receiver_username': message['receiver_username'],
            'content': message['content'],
            'created_at': message['created_at'].strftime('%Y-%m-%d %H:%M:%S')
        }
        for message in messages
    ]

    return jsonify({'success': True, 'messages': formatted_messages})




if __name__ == '__main__':
    app.run(debug=True)
