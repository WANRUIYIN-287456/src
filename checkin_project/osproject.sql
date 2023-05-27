-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 27, 2023 at 02:43 PM
-- Server version: 10.4.25-MariaDB
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `osproject`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_checkin`
--

CREATE TABLE `tbl_checkin` (
  `checkin_id` int(11) NOT NULL,
  `user_id` int(5) NOT NULL,
  `checkin_course` varchar(200) NOT NULL,
  `checkin_group` varchar(10) NOT NULL,
  `checkin_location` varchar(50) NOT NULL,
  `checkin_state` varchar(30) NOT NULL,
  `checkin_lat` varchar(50) NOT NULL,
  `checkin_long` varchar(50) NOT NULL,
  `checkin_date` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_checkin`
--

INSERT INTO `tbl_checkin` (`checkin_id`, `user_id`, `checkin_course`, `checkin_group`, `checkin_location`, `checkin_state`, `checkin_lat`, `checkin_long`, `checkin_date`) VALUES
(3, 3, 'BPME1013 INTRODUCTION TO ENTREPRENEURSHIP ', 'Group A', 'Mountain View', 'California', '37.421998333333335', '-122.08400000000002', '2023-05-27 10:35:32.095670'),
(4, 0, '$checkcourse ', '$checkgrou', '$checklocation', '$checkstate', '$checklat', '$checklong', '2023-05-27 11:20:27.919275'),
(5, 0, ' ', '', '', '', '', '', '2023-05-27 11:36:06.417568'),
(6, 0, '$checkcourse ', '$checkgrou', '$checklocation', '$checkstate', '$checklat', '$checklong', '2023-05-27 11:38:21.666344'),
(7, 0, ' ', '', '', '', '', '', '2023-05-27 12:15:52.065540'),
(8, 3, 'BPME1013 INTRODUCTION TO ENTREPRENEURSHIP ', 'Group A', 'Mountain View', 'California', '37.421998333333335', '-122.08400000000002', '2023-05-27 12:34:46.748673'),
(9, 0, ' ', '', '', '', '', '', '2023-05-27 13:19:40.422781'),
(10, 0, ' ', '', '', '', '', '', '2023-05-27 14:48:21.768131'),
(11, 3, 'STID3074 IT PROJECT MANAGEMENT ', 'Group B', 'Mountain View', 'California', '37.421998333333335', '-122.08400000000002', '2023-05-27 15:28:22.665083');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(5) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `user_phone` varchar(12) NOT NULL,
  `user_password` varchar(40) NOT NULL,
  `user_otp` varchar(6) NOT NULL,
  `user_datereg` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `user_email`, `user_name`, `user_phone`, `user_password`, `user_otp`, `user_datereg`) VALUES
(2, '', '', '', 'da39a3ee5e6b4b0d3255bfef95601890afd80709', '81574', '2023-05-26 21:57:46.705000'),
(3, 'wan@gmail.com', 'WAN RUI YIN', '0125841083', 'a4896125e7f9a2feff67b7967a6a04c2b5b3e0a8', '23387', '2023-05-26 23:08:08.418275'),
(4, '', '', '', 'da39a3ee5e6b4b0d3255bfef95601890afd80709', '46296', '2023-05-27 12:15:57.555599');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_checkin`
--
ALTER TABLE `tbl_checkin`
  ADD PRIMARY KEY (`checkin_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_checkin`
--
ALTER TABLE `tbl_checkin`
  MODIFY `checkin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
