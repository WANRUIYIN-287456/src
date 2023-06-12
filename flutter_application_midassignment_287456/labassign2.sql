-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 12, 2023 at 12:12 PM
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
-- Database: `labassign2`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_barter`
--

CREATE TABLE `tbl_barter` (
  `barter_id` int(6) NOT NULL,
  `user_id` int(6) NOT NULL,
  `barteruser_id` int(6) NOT NULL,
  `barter_date` datetime(6) NOT NULL,
  `product_id` int(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_products`
--

CREATE TABLE `tbl_products` (
  `product_id` int(5) NOT NULL,
  `user_id` int(5) NOT NULL,
  `product_name` varchar(50) NOT NULL,
  `product_desc` varchar(200) NOT NULL,
  `product_type` varchar(20) NOT NULL,
  `product_price` float NOT NULL,
  `product_qty` float NOT NULL,
  `product_long` varchar(100) NOT NULL,
  `product_lat` varchar(100) NOT NULL,
  `product_state` varchar(100) NOT NULL,
  `product_locality` varchar(100) NOT NULL,
  `product_date` date NOT NULL DEFAULT current_timestamp(),
  `Product_Image1` varchar(200) NOT NULL,
  `Product_Image2` varchar(200) NOT NULL,
  `Product_Image3` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_products`
--

INSERT INTO `tbl_products` (`product_id`, `user_id`, `product_name`, `product_desc`, `product_type`, `product_price`, `product_qty`, `product_long`, `product_lat`, `product_state`, `product_locality`, `product_date`, `Product_Image1`, `Product_Image2`, `Product_Image3`) VALUES
(3, 3, 'LED Lights', 'Power-Saving', 'Digital Products', 50, 2, '-122.084', '37.4219983', 'California', 'Mountain View', '2023-05-28', '', '', ''),
(4, 3, 'Kitchen Cabinet', 'Black, new appearance', 'Home & Living', 3000, 1, '-122.084', '37.4219983', 'California', 'Mountain View', '2023-05-30', '', '', ''),
(6, 3, 'Dog Decoration', 'Wooden antique-like decoration', 'Home & Living', 280, 2, '-122.084', '37.4219983', 'California', 'Mountain View', '2023-06-02', '', '', ''),
(7, 3, 'Sofa', 'Luxurious leather-made', 'Home & Living', 4000, 1, '100.5405967', '6.45667', 'Kedah', 'Changlun', '2023-06-09', '', '', ''),
(8, 3, 'Box Decoration', 'Wooden-like', 'Home & Living', 15, 8, '100.5405967', '6.45667', 'Kedah', 'Changlun', '2023-06-09', '', '', ''),
(10, 3, 'Television', 'LG OLED Evo C3 55 inch 4K Smart TV', 'Digital Products', 21000, 1, '100.5405967', '6.45667', 'Kedah', 'Changlun', '2023-06-11', '', '', ''),
(13, 3, 'Panel Curtain', 'French-Pleated, no railing', 'Home & Living', 200, 2, '100.5405967', '6.45667', 'Kedah', 'Changlun', '2023-06-11', '/9j/4QCCRXhpZgAATU0AKgAAAAgABAEAAAMAAAABAlgAAAEBAAMAAAABAZAAAIdpAAQAAAABAAAAPgESAAMAAAABAAAAAAAAAAAAAZIIAAQAAAABAAAAAAAAAAAAAwEAAAMAAAABAlgAAAEBAAMAAAABAZAAAAESAAMAAAABAAAAAAAAAAD/4AAQSkZJRgABAQAAAQAB', '/9j/4QCCRXhpZgAATU0AKgAAAAgABAEAAAMAAAABAlgAAAEBAAMAAAABAZAAAIdpAAQAAAABAAAAPgESAAMAAAABAAAAAAAAAAAAAZIIAAQAAAABAAAAAAAAAAAAAwEAAAMAAAABAlgAAAEBAAMAAAABAZAAAAESAAMAAAABAAAAAAAAAAD/4AAQSkZJRgABAQAAAQAB', '/9j/4QCCRXhpZgAATU0AKgAAAAgABAEAAAMAAAABAlgAAAEBAAMAAAABAZAAAIdpAAQAAAABAAAAPgESAAMAAAABAAAAAAAAAAAAAZIIAAQAAAABAAAAAAAAAAAAAwEAAAMAAAABAlgAAAEBAAMAAAABAZAAAAESAAMAAAABAAAAAAAAAAD/4AAQSkZJRgABAQAAAQAB');

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
(3, 'wan@gmail.com', 'wan rui yin', '0125841083', 'a4896125e7f9a2feff67b7967a6a04c2b5b3e0a8', '88908', '2023-05-17 18:06:17.007332'),
(11, 'wzy@gmail.com', 'zhiyinwan', '0125979984', '5a3083383485e3d829b28cfc1bd0fdfecab9ed31', '70282', '2023-05-17 20:16:42.217847'),
(18, 'wanruiyin@gmail.com', 'WAN RUI YIN', '0125841083', '3c90f25bb6b97b0961f9ab737cf4ef4a65517012', '65132', '2023-05-18 17:55:55.792514'),
(20, 'yyl@gmail.com', 'yap yi lin', '0123457934', '57bbfa494a78f4092c6912ee801c07b86cc78a5d', '16588', '2023-05-19 20:33:22.345379'),
(21, 'sky@gmail.com', 'SIEW KAR ying', '0198765432', '6753f0bacb48cfff86c266fefe17ab2123c71a46', '31775', '2023-05-28 11:13:04.574231');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_barter`
--
ALTER TABLE `tbl_barter`
  ADD PRIMARY KEY (`barter_id`);

--
-- Indexes for table `tbl_products`
--
ALTER TABLE `tbl_products`
  ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_barter`
--
ALTER TABLE `tbl_barter`
  MODIFY `barter_id` int(6) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_products`
--
ALTER TABLE `tbl_products`
  MODIFY `product_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
