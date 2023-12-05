-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 05, 2023 at 01:15 PM
-- Server version: 11.2.2-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `webapp_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `message_id` int(11) NOT NULL,
  `sender_id` int(11) DEFAULT NULL,
  `receiver_username` varchar(255) DEFAULT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `sender_username` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`message_id`, `sender_id`, `receiver_username`, `content`, `created_at`, `sender_username`) VALUES
(36, 1, 'sachi', 'hi', '2023-12-05 07:36:53', 'geco'),
(37, 9, 'geco', 'hi', '2023-12-05 07:46:51', 'sachi'),
(38, 1, 'geco', 'hi', '2023-12-05 08:10:16', 'geco'),
(39, 1, 'sachi', 'AAAADSDASGDKASDASHKJDASKJHDKAJSHDKHASKJDHSAKLJDHJKASHDKJLASHDKJAHSJKAHSKJHAKJSDHJKASHDKJAHDJKAHSHASJKDHALSKJDHAKSJHDKJASDHKAJLSHD', '2023-12-05 08:14:36', 'geco'),
(40, 1, 'panda', 'hi', '2023-12-05 08:31:36', 'geco'),
(41, 10, 'geco', 'hello', '2023-12-05 08:31:55', 'panda'),
(42, 10, 'sachi', 'hi', '2023-12-05 08:32:05', 'panda'),
(43, 1, 'sachi', 'hi', '2023-12-05 08:43:26', 'geco'),
(44, 1, 'sachi', 'hi', '2023-12-05 09:36:27', 'geco'),
(45, 1, 'panda', 'hi', '2023-12-05 10:25:23', 'geco'),
(46, 1, 'geco', 'hi', '2023-12-05 10:26:59', 'geco'),
(47, 1, 'geco', 'hi', '2023-12-05 10:30:09', 'geco'),
(48, 1, 'geco', 'hi', '2023-12-05 10:31:43', 'geco'),
(49, 1, 'geco', 'hi', '2023-12-05 10:33:07', 'geco'),
(50, 1, 'geco', 'hi', '2023-12-05 10:36:30', 'geco'),
(51, 1, 'sachi', 'hi', '2023-12-05 10:38:50', 'geco'),
(52, 1, 'geco', 'hi', '2023-12-05 10:39:44', 'geco'),
(53, 1, 'geco', 'hi', '2023-12-05 10:40:33', 'geco'),
(54, 1, 'geco', 'hi', '2023-12-05 10:43:12', 'geco'),
(55, 1, 'geco', 'hi', '2023-12-05 10:44:21', 'geco'),
(56, 1, 'geco', 'hi', '2023-12-05 10:46:27', 'geco'),
(57, 1, 'sachi', 'hi', '2023-12-05 10:46:33', 'geco'),
(58, 1, 'geco', 'hi', '2023-12-05 10:51:14', 'geco'),
(59, 1, 'panda', 'hello hahahahah', '2023-12-05 11:38:00', 'geco');

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `post_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`post_id`, `user_id`, `content`, `created_at`) VALUES
(38, 1, 'hi', '2023-12-04 15:40:43'),
(39, 9, 'hello', '2023-12-04 15:40:51'),
(40, 10, 'hihi', '2023-12-04 15:41:23');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`) VALUES
(1, 'geco', '123'),
(9, 'sachi', '123'),
(10, 'panda', '123');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `sender_id` (`sender_id`),
  ADD KEY `receiver_username` (`receiver_username`),
  ADD KEY `fk_sender_username` (`sender_username`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`post_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `idx_username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `post_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `fk_sender_username` FOREIGN KEY (`sender_username`) REFERENCES `users` (`username`),
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`receiver_username`) REFERENCES `users` (`username`);

--
-- Constraints for table `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
