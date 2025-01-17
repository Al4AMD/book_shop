-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jan 17, 2025 at 02:31 PM
-- Server version: 8.3.0
-- PHP Version: 8.2.18

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

DROP TABLE IF EXISTS `books`;
CREATE TABLE IF NOT EXISTS `books` (
  `id` int NOT NULL AUTO_INCREMENT,
  `serialNumber` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `cover` varchar(255) NOT NULL,
  `author` varchar(255) NOT NULL,
  `genre` varchar(255) NOT NULL,
  `publicationYear` int NOT NULL,
  `publisher` varchar(255) NOT NULL,
  `price` double NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `serialNumber` (`serialNumber`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`id`, `serialNumber`, `title`, `cover`, `author`, `genre`, `publicationYear`, `publisher`, `price`, `createdAt`, `updatedAt`) VALUES
(4, '12345', 'وقتی نیچه گریست', 'cover/81z5b4ZHKoL._AC_UF1000,1000_QL80_.jpg', 'اروین د. یالوم', 'فلسفی', 1990, 'انتشارات بهرنگ', 192000, '2025-01-17 13:04:22', '2025-01-17 13:04:22'),
(5, '123456', 'شهر استخوان ها', 'cover/91Dz0CVeJyL._UF1000,1000_QL80_.jpg', 'کاساندرا کلیر', 'علمی تخیلی', 2004, 'انتشارات بهرنگ', 12000, '2025-01-17 13:07:29', '2025-01-17 13:14:28');

-- --------------------------------------------------------

--
-- Table structure for table `cart-details`
--

DROP TABLE IF EXISTS `cart-details`;
CREATE TABLE IF NOT EXISTS `cart-details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cartId` int NOT NULL,
  `bookId` int NOT NULL,
  `quantity` int NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `bookId` (`bookId`),
  KEY `cartId` (`cartId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `cart-details`
--

INSERT INTO `cart-details` (`id`, `cartId`, `bookId`, `quantity`, `createdAt`, `updatedAt`) VALUES
(1, 2, 4, 3, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(3, 1, 5, 4, '0000-00-00 00:00:00', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `carts`
--

DROP TABLE IF EXISTS `carts`;
CREATE TABLE IF NOT EXISTS `carts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` int NOT NULL,
  `status` enum('order','purchased') NOT NULL DEFAULT 'order',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `carts`
--

INSERT INTO `carts` (`id`, `userId`, `status`, `createdAt`, `updatedAt`) VALUES
(1, 1, 'purchased', '2025-01-17 13:35:53', '2025-01-17 13:45:18'),
(2, 2, 'order', '2025-01-17 13:36:13', '2025-01-17 13:36:13');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `fullName` varchar(255) NOT NULL,
  `profilePicture` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phoneNumber` varchar(255) DEFAULT NULL,
  `birth` date DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `fullName`, `profilePicture`, `email`, `address`, `phoneNumber`, `birth`, `createdAt`, `updatedAt`) VALUES
(1, 'test', '$2b$15$ufyTQ1VarzwLXwhNZ6y6xeOpDDUa5Xpxx./Pc3mfIJrseO4/U8DOO', 'test3', 'profile/@Wallpaper_4K3D (4045).jpg', 'test@test.com', 'No 5. QC Street', '9562663344', '2025-06-12', '2025-01-15 17:15:46', '2025-01-17 12:32:00'),
(2, 'test2', '$2b$15$rnJwB2840b0NDPQD84Hh2.OBf6RgRB1nWUN8HU3Kaj3s1gURX9JN2', 'test2', '/profiles/@Wallpaper_4K3D (4437).jpg', 'test@te2st.com', 'No 5. QC Street', '95626633', '2025-06-12', '2025-01-15 17:29:48', '2025-01-15 17:29:48');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart-details`
--
ALTER TABLE `cart-details`
  ADD CONSTRAINT `cart-details_ibfk_1` FOREIGN KEY (`bookId`) REFERENCES `books` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `cart-details_ibfk_2` FOREIGN KEY (`cartId`) REFERENCES `carts` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Constraints for table `carts`
--
ALTER TABLE `carts`
  ADD CONSTRAINT `carts_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
