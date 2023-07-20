-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 20, 2023 at 11:13 AM
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
-- Database: `nwarzcom_labassign2`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_cart`
--

CREATE TABLE `tbl_cart` (
  `cart_id` int(6) NOT NULL,
  `cart_qty` int(6) NOT NULL,
  `cart_price` float NOT NULL,
  `user_id` varchar(6) NOT NULL,
  `barteruser_id` varchar(6) NOT NULL,
  `cart_date` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `product_id` varchar(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_order`
--

CREATE TABLE `tbl_order` (
  `order_id` int(6) NOT NULL,
  `barterorder_id` varchar(6) NOT NULL,
  `paymentorder_id` varchar(6) NOT NULL,
  `product_id` varchar(6) NOT NULL,
  `order_date` datetime(6) DEFAULT current_timestamp(6),
  `order_qty` int(10) NOT NULL,
  `barteruser_id` varchar(6) NOT NULL,
  `user_id` varchar(6) NOT NULL,
  `order_status` varchar(15) NOT NULL,
  `owner_status` varchar(30) NOT NULL,
  `buyer_status` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_order`
--

INSERT INTO `tbl_order` (`order_id`, `barterorder_id`, `paymentorder_id`, `product_id`, `order_date`, `order_qty`, `barteruser_id`, `user_id`, `order_status`, `owner_status`, `buyer_status`) VALUES
(53, '24', '', '3', '2023-07-20 16:21:52.226444', 1, '24', '3', 'Barter', 'Completed', 'Completed'),
(54, '', '30', '4', '2023-07-20 16:21:57.799479', 1, '24', '3', 'Paid', 'Completed', 'Completed');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_orderbarter`
--

CREATE TABLE `tbl_orderbarter` (
  `barterorder_id` int(6) NOT NULL,
  `product_id` varchar(6) NOT NULL,
  `barterproduct_id` varchar(6) NOT NULL,
  `barterproduct_name` varchar(30) NOT NULL,
  `barterorder_status` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_orderbarter`
--

INSERT INTO `tbl_orderbarter` (`barterorder_id`, `product_id`, `barterproduct_id`, `barterproduct_name`, `barterorder_status`) VALUES
(24, '3', '28', 'Kitty', 'Accepted');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_orderpay`
--

CREATE TABLE `tbl_orderpay` (
  `paymentorder_id` int(6) NOT NULL,
  `product_id` varchar(6) NOT NULL,
  `product_name` varchar(30) NOT NULL,
  `payment_amount` float NOT NULL,
  `paymentorder_status` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_orderpay`
--

INSERT INTO `tbl_orderpay` (`paymentorder_id`, `product_id`, `product_name`, `payment_amount`, `paymentorder_status`) VALUES
(30, '4', 'Kitchen Cabinet', 3000, 'Ready');

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
  `Product_Image3` varchar(200) NOT NULL,
  `product_option` varchar(15) NOT NULL,
  `product_status` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_products`
--

INSERT INTO `tbl_products` (`product_id`, `user_id`, `product_name`, `product_desc`, `product_type`, `product_price`, `product_qty`, `product_long`, `product_lat`, `product_state`, `product_locality`, `product_date`, `Product_Image1`, `Product_Image2`, `Product_Image3`, `product_option`, `product_status`) VALUES
(3, 3, 'LED Lights', 'Power-Saving', 'Digital Products', 50, 2, '-122.084', '37.4219983', 'California', 'Mountain View', '2023-05-28', '', '', '', 'Barter', 'New'),
(4, 3, 'Kitchen Cabinet', 'Black, new appearance', 'Home & Living', 3000, 1, '-122.084', '37.4219983', 'California', 'Mountain View', '2023-05-30', '', '', '', 'Sell', 'New'),
(6, 3, 'Dog Decoration', 'Wooden antique-like decoration', 'Home & Living', 280, 2, '-122.084', '37.4219983', 'California', 'Mountain View', '2023-06-02', '', '', '', 'Barter', 'New'),
(7, 3, 'Sofa', 'Luxurious leather-made', 'Home & Living', 4000, 1, '100.5405967', '6.45667', 'Kedah', 'Changlun', '2023-06-09', '', '', '', 'Sell', 'New'),
(8, 3, 'Box Decoration', 'Wooden-like', 'Home & Living', 15, 8, '100.5405967', '6.45667', 'Kedah', 'Changlun', '2023-06-09', '', '', '', 'Barter', 'New'),
(10, 3, 'Television', 'LG OLED Evo C3 55 inch 4K Smart TV', 'Digital Products', 21000, 1, '100.5405967', '6.45667', 'Kedah', 'Changlun', '2023-06-11', '', '', '', 'Sell', 'New'),
(13, 3, 'Panel Curtain', 'French-Pleated, no railing', 'Home & Living', 200, 2, '100.5405967', '6.45667', 'Kedah', 'Changlun', '2023-06-11', '/9j/4QCCRXhpZgAATU0AKgAAAAgABAEAAAMAAAABAlgAAAEBAAMAAAABAZAAAIdpAAQAAAABAAAAPgESAAMAAAABAAAAAAAAAAAAAZIIAAQAAAABAAAAAAAAAAAAAwEAAAMAAAABAlgAAAEBAAMAAAABAZAAAAESAAMAAAABAAAAAAAAAAD/4AAQSkZJRgABAQAAAQAB', '/9j/4QCCRXhpZgAATU0AKgAAAAgABAEAAAMAAAABAlgAAAEBAAMAAAABAZAAAIdpAAQAAAABAAAAPgESAAMAAAABAAAAAAAAAAAAAZIIAAQAAAABAAAAAAAAAAAAAwEAAAMAAAABAlgAAAEBAAMAAAABAZAAAAESAAMAAAABAAAAAAAAAAD/4AAQSkZJRgABAQAAAQAB', '/9j/4QCCRXhpZgAATU0AKgAAAAgABAEAAAMAAAABAlgAAAEBAAMAAAABAZAAAIdpAAQAAAABAAAAPgESAAMAAAABAAAAAAAAAAAAAZIIAAQAAAABAAAAAAAAAAAAAwEAAAMAAAABAlgAAAEBAAMAAAABAZAAAAESAAMAAAABAAAAAAAAAAD/4AAQSkZJRgABAQAAAQAB', 'Barter', 'New'),
(14, 3, 'Table', 'wooden, antique', 'Home & Living', 30, 2, '100.5405967', '6.45667', 'Kedah', 'Changlun', '2023-07-16', '', '', '', 'Barter', 'New'),
(26, 24, 'Floor Mat', 'new and nice', 'Home & Living', 5, 2, '100.5405967', '6.45667', 'Kedah', 'Changlun', '2023-07-18', '/9j/4QCCRXhpZgAATU0AKgAAAAgABAEAAAMAAAABAlgAAAEBAAMAAAABAZAAAIdpAAQAAAABAAAAPgESAAMAAAABAAAAAAAAAAAAAZIIAAQAAAABAAAAAAAAAAAAAwEAAAMAAAABAlgAAAEBAAMAAAABAZAAAAESAAMAAAABAAAAAAAAAAD/4AAQSkZJRgABAQAAAQAB', '/9j/4QCCRXhpZgAATU0AKgAAAAgABAEAAAMAAAABAlgAAAEBAAMAAAABAZAAAIdpAAQAAAABAAAAPgESAAMAAAABAAAAAAAAAAAAAZIIAAQAAAABAAAAAAAAAAAAAwEAAAMAAAABAlgAAAEBAAMAAAABAZAAAAESAAMAAAABAAAAAAAAAAD/4AAQSkZJRgABAQAAAQAB', '/9j/4QCCRXhpZgAATU0AKgAAAAgABAEAAAMAAAABAlgAAAEBAAMAAAABAZAAAIdpAAQAAAABAAAAPgESAAMAAAABAAAAAAAAAAAAAZIIAAQAAAABAAAAAAAAAAAAAwEAAAMAAAABAlgAAAEBAAMAAAABAZAAAAESAAMAAAABAAAAAAAAAAD/4AAQSkZJRgABAQAAAQAB', 'Barter', ''),
(28, 24, 'Kitty', 'White, smooth decoration', 'Others', 50, 1, '100.54059666666666', '6.456670000000001', 'Kedah', 'Changlun', '2023-07-19', '/9j/4QCCRXhpZgAATU0AKgAAAAgABAEAAAMAAAABAlgAAAEBAAMAAAABAZAAAIdpAAQAAAABAAAAPgESAAMAAAABAAAAAAAAAAAAAZIIAAQAAAABAAAAAAAAAAAAAwEAAAMAAAABAlgAAAEBAAMAAAABAZAAAAESAAMAAAABAAAAAAAAAAD/4AAQSkZJRgABAQAAAQAB', '/9j/4QCCRXhpZgAATU0AKgAAAAgABAEAAAMAAAABAlgAAAEBAAMAAAABAZAAAIdpAAQAAAABAAAAPgESAAMAAAABAAAAAAAAAAAAAZIIAAQAAAABAAAAAAAAAAAAAwEAAAMAAAABAlgAAAEBAAMAAAABAZAAAAESAAMAAAABAAAAAAAAAAD/4AAQSkZJRgABAQAAAQAB', '/9j/4QCCRXhpZgAATU0AKgAAAAgABAEAAAMAAAABAlgAAAEBAAMAAAABAZAAAIdpAAQAAAABAAAAPgESAAMAAAABAAAAAAAAAAAAAZIIAAQAAAABAAAAAAAAAAAAAwEAAAMAAAABAlgAAAEBAAMAAAABAZAAAAESAAMAAAABAAAAAAAAAAD/4AAQSkZJRgABAQAAAQAB', 'Barter', 'New');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_profile`
--

CREATE TABLE `tbl_profile` (
  `user_id` int(6) NOT NULL,
  `user_name` varchar(30) NOT NULL,
  `user_phone` varchar(30) NOT NULL,
  `user_email` varchar(30) NOT NULL,
  `user_image` varchar(40) NOT NULL,
  `user_datereg` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tbl_profile`
--

INSERT INTO `tbl_profile` (`user_id`, `user_name`, `user_phone`, `user_email`, `user_image`, `user_datereg`) VALUES
(3, 'Wan Rui Yin', 'wan@gmail.com', 'wan@gmail.com', '/9j/4QBqRXhpZgAATU0AKgAAAAgABAEAAAQAAAAB', '2023-05-17 18:06:17.007332');

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
(3, 'wan@gmail.com', 'Wan Rui Yin', '0125623568', 'a4896125e7f9a2feff67b7967a6a04c2b5b3e0a8', '88908', '2023-05-17 18:06:17.007332'),
(11, 'wzy@gmail.com', 'zhiyinwan', '0125979984', '5a3083383485e3d829b28cfc1bd0fdfecab9ed31', '70282', '2023-05-17 20:16:42.217847'),
(18, 'wanruiyin@gmail.com', 'WAN RUI YIN', '0125841083', '3c90f25bb6b97b0961f9ab737cf4ef4a65517012', '65132', '2023-05-18 17:55:55.792514'),
(20, 'yyl@gmail.com', 'yap yi lin', '0123457934', '57bbfa494a78f4092c6912ee801c07b86cc78a5d', '16588', '2023-05-19 20:33:22.345379'),
(21, 'sky@gmail.com', 'SIEW KAR ying', '0198765432', '6753f0bacb48cfff86c266fefe17ab2123c71a46', '31775', '2023-05-28 11:13:04.574231'),
(24, 'ljy@gmail.com', 'loh jia yi', '0175638968', 'd5c3c09badd2016e68459eb7720e813956cfc15e', '50919', '2023-06-30 14:41:00.480213');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_cart`
--
ALTER TABLE `tbl_cart`
  ADD PRIMARY KEY (`cart_id`);

--
-- Indexes for table `tbl_order`
--
ALTER TABLE `tbl_order`
  ADD PRIMARY KEY (`order_id`);

--
-- Indexes for table `tbl_orderbarter`
--
ALTER TABLE `tbl_orderbarter`
  ADD PRIMARY KEY (`barterorder_id`);

--
-- Indexes for table `tbl_orderpay`
--
ALTER TABLE `tbl_orderpay`
  ADD PRIMARY KEY (`paymentorder_id`);

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
-- AUTO_INCREMENT for table `tbl_cart`
--
ALTER TABLE `tbl_cart`
  MODIFY `cart_id` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- AUTO_INCREMENT for table `tbl_order`
--
ALTER TABLE `tbl_order`
  MODIFY `order_id` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `tbl_orderbarter`
--
ALTER TABLE `tbl_orderbarter`
  MODIFY `barterorder_id` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `tbl_orderpay`
--
ALTER TABLE `tbl_orderpay`
  MODIFY `paymentorder_id` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `tbl_products`
--
ALTER TABLE `tbl_products`
  MODIFY `product_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
