SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mms_db`
--

-- --------------------------------------------------------
-- Table structure for table `user`
--
CREATE TABLE `user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(20) NOT NULL DEFAULT 'COMMUNITY',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user`
--
INSERT INTO `user` (`user_id`, `name`, `email`, `phone`, `password`, `role`, `created_at`) VALUES
(1, 'Koordinator Masjid', 'coordinator@mms.com', '0123456789', 'admin123', 'COORDINATOR', '2025-12-30 10:35:24'),
(2, 'Ali Bin Abu', 'ali@mms.test', '0191111111', 'ali123', 'COMMUNITY', '2025-12-30 10:35:24'),
(3, 'izzati', 'ijat@gmail.com', '011-26469852', '123456', 'COMMUNITY', '2025-12-30 11:09:05'),
(4, 'abu', 'abu@gmail.com', '011-26469852', '2468', 'COMMUNITY', '2025-12-30 14:09:06'),
(5, 'Huda', 'hudarangers@gmail.com', '011-26469853', 'ABU', 'COMMUNITY', '2025-12-31 07:55:34'),
(6, 'abu', 'abu123@gmail.com', '011-26469855', '123abu', 'COMMUNITY', '2026-01-03 14:48:50'),
(7, 'husna', 'husna@gmail.com', '011-26469856', '12husna', 'COMMUNITY', '2026-01-03 15:24:47'),
(9, 'Bendahari Masjid', 'treasurer@mms.com', '0111234567', 'treasurer123', 'TREASURER', '2026-04-06 05:40:04'),
(10, 'Mayo', 'mayo@gmail.com', '01234567', '1234', 'COMMUNITY', '2026-04-08 07:31:16');

-- --------------------------------------------------------
-- Table structure for table `facility`
--
CREATE TABLE `facility` (
  `facility_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `type` varchar(50) NOT NULL,
  `capacity` int(11) NOT NULL DEFAULT 0,
  `rate_per_day` decimal(10,2) NOT NULL DEFAULT 0.00,
  `half_day_rate` decimal(10,2) DEFAULT 0.00,
  `status` varchar(20) DEFAULT 'AVAILABLE',
  PRIMARY KEY (`facility_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `facility`
--
INSERT INTO `facility` (`facility_id`, `name`, `type`, `capacity`, `rate_per_day`, `half_day_rate`, `status`) VALUES
(1, 'Fasiliti Masjid (Dewan Utama)', 'Dewan', 500, 100.00, 50.00, 'AVAILABLE'),
(2, 'Bilik Seminar', 'Bilik', 50, 50.00, 25.00, 'AVAILABLE'),
(3, 'Tapak Program Luar', 'Tapak', 200, 50.00, 25.00, 'AVAILABLE');

-- --------------------------------------------------------
-- Table structure for table `booking`
--
CREATE TABLE `booking` (
  `booking_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `facility_id` int(11) DEFAULT NULL,
  `address` varchar(255) NOT NULL,
  `booking_type` varchar(255) DEFAULT NULL,
  `session_type` varchar(20) DEFAULT 'FULL_DAY',
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `total_days` int(11) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `status` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`booking_id`),
  KEY `fk_booking_user` (`user_id`),
  KEY `fk_booking_facility` (`facility_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `booking`
--
INSERT INTO `booking` (`booking_id`, `user_id`, `facility_id`, `address`, `booking_type`, `session_type`, `start_time`, `end_time`, `start_date`, `end_date`, `total_days`, `total_amount`, `status`, `created_at`, `email`, `phone`) VALUES
(1, 4, NULL, 'ifijfr', 'Fasiliti Masjid', 'FULL_DAY', NULL, NULL, '2025-12-30', '2026-01-01', 3, 30.00, 'PENDING', '2025-12-30 14:11:25', NULL, NULL),
(2, 3, NULL, 'ifijfr', 'Fasiliti Masjid', 'FULL_DAY', NULL, NULL, '2025-12-30', '2026-01-01', 3, 30.00, 'PENDING', '2025-12-30 15:02:02', NULL, NULL),
(3, 3, NULL, 'ifijfr', 'Fasiliti Masjid', 'FULL_DAY', NULL, NULL, '2025-12-30', '2026-01-08', 10, 100.00, 'PENDING', '2025-12-30 15:46:52', NULL, NULL),
(4, 3, NULL, 'ifijfr', 'Fasiliti Masjid', 'FULL_DAY', NULL, NULL, '2025-12-30', '2026-01-01', 3, 30.00, 'PENDING', '2025-12-30 15:47:45', NULL, NULL),
(5, 3, NULL, 'ifijfr', 'Fasiliti Masjid', 'FULL_DAY', NULL, NULL, '2025-12-30', '2025-12-31', 2, 20.00, 'APPROVED', '2025-12-30 15:49:16', NULL, NULL),
(6, 3, NULL, '345 jalan gong pak jin', 'Bilik Seminar', 'FULL_DAY', NULL, NULL, '2025-12-30', '2025-12-31', 2, 20.00, 'REJECTED', '2025-12-30 15:53:10', NULL, NULL),
(7, 3, NULL, '345 jalan gong pak ', 'Fasiliti Masjid', 'FULL_DAY', NULL, NULL, '2025-12-31', '2026-01-01', 2, 20.00, 'APPROVED', '2025-12-30 16:00:46', NULL, NULL),
(8, 3, NULL, '345 jalan gong pak jin', 'Fasiliti Masjid', 'FULL_DAY', NULL, NULL, '2025-12-31', '2025-12-31', 1, 10.00, 'APPROVED', '2025-12-30 16:51:43', NULL, NULL),
(9, 5, NULL, 'library', 'Bilik Seminar', 'FULL_DAY', NULL, NULL, '2025-12-31', '2026-01-02', 3, 30.00, 'REJECTED', '2025-12-31 07:56:21', NULL, NULL),
(10, 3, NULL, '345 jalan gong pak jin', 'Tapak Program Luar', 'FULL_DAY', NULL, NULL, '2026-01-01', '2026-01-02', 2, 20.00, 'REJECTED', '2026-01-01 08:23:36', NULL, NULL),
(11, 6, NULL, '345 jalan gong pak jin', 'Bilik Seminar', 'FULL_DAY', NULL, NULL, '2026-01-20', '2026-01-21', 2, 20.00, 'REJECTED', '2026-01-03 14:50:08', NULL, NULL),
(12, 7, NULL, '345 jalan gong pak jin', 'Fasiliti Masjid', 'FULL_DAY', NULL, NULL, '2026-01-16', '2026-01-18', 3, 30.00, 'APPROVED', '2026-01-03 15:26:17', NULL, NULL),
(13, 3, NULL, '345 jalan gong pak jin', 'Fasiliti Masjid', 'FULL_DAY', NULL, NULL, '2026-01-23', '2026-01-24', 2, 20.00, 'PENDING', '2026-01-19 05:20:02', NULL, NULL),
(14, 3, 1, '345 jalan gong pak jin', 'Fasiliti Masjid', 'FULL_DAY', NULL, NULL, '2026-01-19', '2026-01-20', 2, 20.00, 'APPROVED', '2026-01-19 15:52:13', NULL, NULL),
(15, 3, 1, '345 jalan gong pak jin', 'Fasiliti Masjid', 'FULL_DAY', NULL, NULL, '2026-01-19', '2026-01-20', 2, 20.00, 'REJECTED', '2026-01-19 15:52:22', NULL, NULL),
(16, 3, 2, '345 jalan gong pak jin', 'Fasiliti Masjid', 'FULL_DAY', NULL, NULL, '2026-01-29', '2026-01-30', 2, 20.00, 'APPROVED', '2026-01-19 15:53:26', NULL, NULL),
(17, 3, 1, '345 jalan gong pak jin', 'Fasiliti Masjid', 'FULL_DAY', NULL, NULL, '2026-01-20', '2026-01-21', 2, 20.00, 'REJECTED', '2026-01-20 06:08:49', NULL, NULL),
(18, 3, 1, '345 jalan gong pak jin', 'Kenduri', 'FULL_DAY', NULL, NULL, '2026-01-20', '2026-01-21', 2, 20.00, 'APPROVED', '2026-01-20 07:54:47', 'ijat@gmail.com', '011-26469852'),
(19, 3, 1, '345 jalan gong pak jin', 'Kenduri', 'FULL_DAY', NULL, NULL, '2026-01-20', '2026-01-21', 2, 20.00, 'APPROVED', '2026-01-20 07:59:03', 'ijat@gmail.com', '011-26469852'),
(20, 3, 1, '345 jalan gong pak jin', 'Kenduri', 'FULL_DAY', NULL, NULL, '2026-01-20', '2026-01-21', 2, 20.00, 'REJECTED', '2026-01-20 08:02:31', 'ijat@gmail.com', '011-26469852'),
(21, 3, 1, '345 jalan gong pak jin', 'Kenduri', 'FULL_DAY', NULL, NULL, '2026-01-20', '2026-01-21', 2, 20.00, 'APPROVED', '2026-01-20 08:02:56', 'ijat@gmail.com', '011-26469852'),
(22, 3, 1, '345 jalan gong pak jin', 'Kenduri', 'FULL_DAY', NULL, NULL, '2026-01-20', '2026-01-21', 2, 20.00, 'REJECTED', '2026-01-20 08:03:49', 'ijat@gmail.com', '011-26469852'),
(23, 3, 1, '345 jalan gong pak jin', 'Kenduri', 'FULL_DAY', NULL, NULL, '2026-01-20', '2026-01-21', 2, 20.00, 'APPROVED', '2026-01-20 08:09:29', 'ijat@gmail.com', '011-26469852'),
(24, 3, 1, '345 jalan gong pak jin', 'Kenduri', 'FULL_DAY', NULL, NULL, '2026-01-20', '2026-01-21', 2, 20.00, 'REJECTED', '2026-01-20 08:11:57', 'ijat@gmail.com', '011-26469852'),
(25, 3, 1, '345 jalan gong pak jin', 'Kenduri', 'FULL_DAY', NULL, NULL, '2026-01-20', '2026-01-21', 2, 20.00, 'CANCELED', '2026-01-20 09:30:46', 'ijat@gmail.com', '011-26469852'),
(26, 3, 1, '345 jalan gong pak jin', 'Kenduri', 'FULL_DAY', NULL, NULL, '2026-01-20', '2026-01-21', 2, 20.00, 'CANCELED', '2026-01-20 10:49:20', 'ijat@gmail.com', '011-26469852'),
(27, 3, 2, '345 jalan gong pak jin', 'Lain-lain', 'FULL_DAY', NULL, NULL, '2026-01-23', '2026-01-22', 0, 0.00, 'CANCELED', '2026-01-20 10:53:09', 'ijat@gmail.com', '011-26469852'),
(28, 3, 1, '345 jalan gong pak jin', 'Kenduri', 'FULL_DAY', NULL, NULL, '2026-01-22', '2026-01-23', 2, 20.00, 'CANCELED', '2026-01-20 10:53:30', 'ijat@gmail.com', '011-26469852'),
(29, 3, 1, '345 jalan gong pak jin', 'Kenduri', 'FULL_DAY', NULL, NULL, '2026-01-21', '2026-01-22', 2, 20.00, 'CANCELED', '2026-01-21 01:17:01', 'ijat@gmail.com', '011-26469852'),
(30, 3, 1, '345 jalan gong pak jin', 'Kenduri', 'FULL_DAY', NULL, NULL, '2026-04-04', '2026-04-10', 7, 70.00, 'CANCELED', '2026-04-02 13:25:54', 'ijat@gmail.com', '011-26469852'),
(31, 3, 1, '345 jalan gong pak jin', 'Kenduri', 'FULL_DAY', NULL, NULL, '2026-04-09', '2026-04-10', 2, 20.00, 'CANCELED', '2026-04-07 17:20:23', 'ijat@gmail.com', '011-26469852'),
(32, 3, 1, '345 jalan gong pak jin', 'Kenduri', 'FULL_DAY', NULL, NULL, '2026-04-08', '2026-04-09', 2, 20.00, 'PENDING', '2026-04-08 06:59:11', 'ijat@gmail.com', '011-26469852'),
(33, 10, 1, '345 jalan gong pak jin', 'Lain-lain', 'FULL_DAY', NULL, NULL, '2026-04-09', '2026-04-10', 2, 20.00, 'CANCELED', '2026-04-08 07:38:13', 'mayo@gmail.com', '012345678'),
(34, 3, 1, '345 jalan gong pak jin', 'Kenduri', 'HALF_DAY', '17:00:00', '22:30:00', '2026-04-16', '2026-04-16', 1, 50.00, 'PENDING', '2026-04-12 18:06:45', 'ijat@gmail.com', '011-26469852'),
(35, 3, 1, '345 jalan gong pak jin', 'Kenduri', 'HALF_DAY', '17:00:00', '22:30:00', '2026-04-16', '2026-04-16', 1, 50.00, 'CANCELED', '2026-04-12 18:06:48', 'ijat@gmail.com', '011-26469852');

-- --------------------------------------------------------
-- Table structure for table `billing`
--
CREATE TABLE `billing` (
  `bill_id` int(11) NOT NULL AUTO_INCREMENT,
  `booking_id` int(11) NOT NULL,
  `bill_type` varchar(50) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `bill_date` date NOT NULL,
  `due_date` date DEFAULT NULL,
  `status` varchar(20) DEFAULT 'PENDING',
  `receipt_image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`bill_id`),
  KEY `fk_billing_booking` (`booking_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `donation`
--
CREATE TABLE `donation` (
  `donation_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `donor_name` varchar(100) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `donation_type` varchar(50) DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `date` date NOT NULL,
  `notes` text DEFAULT NULL,
  `status` varchar(20) DEFAULT 'PENDING',
  PRIMARY KEY (`donation_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `donation`
--
INSERT INTO `donation` (`donation_id`, `user_id`, `donor_name`, `amount`, `donation_type`, `payment_method`, `date`, `notes`, `status`) VALUES
(1, 3, 'izzati', 10.00, 'Program Ilmu', 'Tunai', '2026-04-06', 'pahala', 'SUCCESS');

-- --------------------------------------------------------
-- Table structure for table `event`
--
CREATE TABLE `event` (
  `event_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `date` date NOT NULL,
  `time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `status` varchar(20) DEFAULT 'UPCOMING',
  `request_status` varchar(20) DEFAULT 'APPROVED',
  `requested_by` int(11) DEFAULT NULL,
  `approved_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`event_id`),
  KEY `user_id` (`user_id`),
  KEY `fk_event_requested_by` (`requested_by`),
  KEY `fk_event_approved_by` (`approved_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `event`
--
INSERT INTO `event` (`event_id`, `user_id`, `name`, `date`, `time`, `end_time`, `location`, `description`, `status`, `request_status`, `requested_by`, `approved_by`) VALUES
(2, 3, 'kenduri', '2026-04-10', '16:20:00', NULL, 'Dewan Belajar', 'kenduri', 'UPCOMING', 'APPROVED', 3, NULL),
(3, 3, 'Kuliah Magrib', '2026-04-08', '14:20:00', NULL, 'Dewan Solat Utama', 'ceramah berkaitan dengan puasa', 'ONGOING', 'APPROVED', 3, NULL),
(4, 3, 'Gotong - Royong Masjid', '2026-04-08', '08:45:00', NULL, 'Perkarangan Masjid', 'Ahli kampung bersama\" bergotong royong di perkarangan masjid', 'COMPLETED', 'APPROVED', 3, NULL);

-- --------------------------------------------------------
-- Table structure for table `payment`
--
CREATE TABLE `payment` (
  `payment_id` int(11) NOT NULL AUTO_INCREMENT,
  `booking_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `method` varchar(50) DEFAULT NULL,
  `paid_at` datetime DEFAULT NULL,
  `status` enum('PENDING','SUCCESS','FAILED') DEFAULT 'PENDING',
  `bill_code` varchar(100) DEFAULT NULL,
  `gateway` varchar(30) DEFAULT 'TOYYIBPAY',
  PRIMARY KEY (`payment_id`),
  KEY `fk_payment_booking` (`booking_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `notification`
--
CREATE TABLE IF NOT EXISTS `notification` (
    `notif_id`   INT AUTO_INCREMENT PRIMARY KEY,
    `user_id`    INT NOT NULL,
    `type`       VARCHAR(50) NOT NULL,
    `message`    TEXT NOT NULL,
    `is_read`    TINYINT(1) DEFAULT 0,
    `ref_id`     INT DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_notification_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Constraints for dumped tables
--
ALTER TABLE `billing`
  ADD CONSTRAINT `fk_billing_booking` FOREIGN KEY (`booking_id`) REFERENCES `booking` (`booking_id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `booking`
  ADD CONSTRAINT `fk_booking_facility` FOREIGN KEY (`facility_id`) REFERENCES `facility` (`facility_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_booking_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `donation`
  ADD CONSTRAINT `donation_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE SET NULL;

ALTER TABLE `event`
  ADD CONSTRAINT `event_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_event_approved_by` FOREIGN KEY (`approved_by`) REFERENCES `user` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_event_requested_by` FOREIGN KEY (`requested_by`) REFERENCES `user` (`user_id`) ON DELETE SET NULL;

ALTER TABLE `payment`
  ADD CONSTRAINT `fk_payment_booking` FOREIGN KEY (`booking_id`) REFERENCES `booking` (`booking_id`) ON DELETE CASCADE ON UPDATE CASCADE;

COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
