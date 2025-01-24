-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jan 22, 2025 at 06:27 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `book-store`
--

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `id` int(11) NOT NULL,
  `serialNumber` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `cover` varchar(255) NOT NULL,
  `author` varchar(255) NOT NULL,
  `genre` varchar(255) NOT NULL,
  `publicationYear` int(11) NOT NULL,
  `publisher` varchar(255) NOT NULL,
  `price` double NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`id`, `serialNumber`, `title`, `cover`, `author`, `genre`, `publicationYear`, `publisher`, `price`, `createdAt`, `updatedAt`) VALUES
(4, '12345', 'When Nietzche Wept', 'cover/81z5b4ZHKoL._AC_UF1000,1000_QL80_.jpg', 'Ervin D. Yalom', 'Philosophy', 1990, 'Behrang', 192000, '2025-01-17 13:04:22', '2025-01-17 13:04:22'),
(5, '123456', 'City of Bones', 'cover/91Dz0CVeJyL._UF1000,1000_QL80_.jpg', 'Cassandra Clare', 'Sci-Fi', 2004, 'Behrang', 120000, '2025-01-17 13:07:29', '2025-01-17 13:14:28'),
(6, '1234561', 'The Great Gatsby', 'cover/41733839.jpg', 'F. Scott Fitzgerald', 'Fiction', 2004, 'Behrang', 180000, '2025-01-21 17:35:32', '2025-01-21 17:35:32'),
(7, '1234562', '1984', 'cover/61439040.jpg', 'George Orwell', 'Fiction', 2002, 'Behrang', 120000, '2025-01-21 17:36:51', '2025-01-21 17:36:51');

-- --------------------------------------------------------

--
-- Table structure for table `cart-details`
--

CREATE TABLE `cart-details` (
  `id` int(11) NOT NULL,
  `cartId` int(11) NOT NULL,
  `bookId` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cart-details`
--

INSERT INTO `cart-details` (`id`, `cartId`, `bookId`, `quantity`, `createdAt`, `updatedAt`) VALUES
(7, 6, 4, 2, '2025-01-22 00:17:26', '2025-01-22 00:17:26'),
(8, 6, 5, 2, '2025-01-22 00:17:26', '2025-01-22 00:17:26'),
(9, 6, 7, 1, '2025-01-22 00:17:26', '2025-01-22 00:17:26'),
(10, 7, 7, 4, '2025-01-22 00:18:06', '2025-01-22 00:18:06');

-- --------------------------------------------------------

--
-- Table structure for table `carts`
--

CREATE TABLE `carts` (
  `id` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `status` enum('order','purchased') NOT NULL DEFAULT 'order',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `carts`
--

INSERT INTO `carts` (`id`, `userId`, `status`, `createdAt`, `updatedAt`) VALUES
(6, 1, 'order', '2025-01-21 22:10:06', '2025-01-21 22:10:06'),
(7, 1, 'order', '2025-01-22 00:17:57', '2025-01-22 00:17:57');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `fullName` varchar(255) NOT NULL,
  `profilePicture` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phoneNumber` varchar(255) DEFAULT NULL,
  `birth` date DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `fullName`, `profilePicture`, `email`, `address`, `phoneNumber`, `birth`, `createdAt`, `updatedAt`) VALUES
(1, 'test', '$2b$15$ufyTQ1VarzwLXwhNZ6y6xeOpDDUa5Xpxx./Pc3mfIJrseO4/U8DOO', 'test3', '/profiles/@Wallpaper_4K3D (4045).jpg', 'test@test.com', 'No 5. QC Street', '9562663344', '2025-06-12', '2025-01-15 17:15:46', '2025-01-17 12:32:00'),
(2, 'test2', '$2b$15$rnJwB2840b0NDPQD84Hh2.OBf6RgRB1nWUN8HU3Kaj3s1gURX9JN2', 'test2', '/profiles/@Wallpaper_4K3D (4437).jpg', 'test@te2st.com', 'No 5. QC Street', '95626633', '2025-06-12', '2025-01-15 17:29:48', '2025-01-15 17:29:48'),
(3, 'mobile', '$2b$15$Pl363kf2rYMplb4LNwxxuuEI9GgvuOgznK188wUnHzrxjp6Rvs9cm', 'mobile', '/profiles/1000000033.jpg', 'mobile@gmail.com', 'mobile', '9912087114', '2025-01-02', '2025-01-20 21:57:19', '2025-01-20 21:57:19');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `serialNumber` (`serialNumber`);

--
-- Indexes for table `cart-details`
--
ALTER TABLE `cart-details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bookId` (`bookId`),
  ADD KEY `cartId` (`cartId`);

--
-- Indexes for table `carts`
--
ALTER TABLE `carts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userId` (`userId`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `books`
--
ALTER TABLE `books`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `cart-details`
--
ALTER TABLE `cart-details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `carts`
--
ALTER TABLE `carts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart-details`
--
ALTER TABLE `cart-details`
  ADD CONSTRAINT `cart-details_ibfk_1` FOREIGN KEY (`bookId`) REFERENCES `books` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `cart-details_ibfk_2` FOREIGN KEY (`cartId`) REFERENCES `carts` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `carts`
--
ALTER TABLE `carts`
  ADD CONSTRAINT `carts_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
