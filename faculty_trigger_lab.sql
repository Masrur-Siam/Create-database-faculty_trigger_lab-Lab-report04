-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 13, 2026 at 05:05 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `faculty_trigger_lab`
--

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `EmpID` int(11) NOT NULL,
  `EmpName` varchar(100) NOT NULL,
  `BasicSalary` decimal(10,2) NOT NULL,
  `StartDate` date NOT NULL,
  `NoOfPub` int(11) NOT NULL CHECK (`NoOfPub` >= 0),
  `IncrementRate` decimal(5,2) DEFAULT 0.00,
  `UpdatedSalary` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`EmpID`, `EmpName`, `BasicSalary`, `StartDate`, `NoOfPub`, `IncrementRate`, `UpdatedSalary`) VALUES
(101, 'Dr. Ariful Islam', 50000.00, '2022-01-10', 6, 20.00, 60000.00),
(102, 'Dr. Nusrat Jahan', 45000.00, '2023-05-15', 3, 10.00, 49500.00),
(103, 'Prof. Sabbir Ahmed', 60000.00, '2021-03-20', 1, 5.00, 63000.00),
(104, 'Ms. Anika Tabassum', 40000.00, '2024-11-01', 6, 20.00, 48000.00),
(105, 'Dr. Mehedi Hasan', 55000.00, '2022-06-12', 0, 0.00, NULL),
(106, 'Mr. Sajid Hasan', 38000.00, '2020-08-25', 2, 0.00, NULL),
(107, 'Dr. Farhana Khan', 52000.00, '2023-01-01', 4, 0.00, NULL),
(108, 'Prof. Tanvir Ahmed', 65000.00, '2019-12-12', 10, 0.00, NULL);

--
-- Triggers `employee`
--
DELIMITER $$
CREATE TRIGGER `trg_calculate_increment` BEFORE UPDATE ON `employee` FOR EACH ROW BEGIN
    DECLARE job_duration INT;
    SET job_duration = TIMESTAMPDIFF(YEAR, OLD.StartDate, CURDATE());
    
    IF job_duration >= 1 AND NEW.NoOfPub > 4 THEN
        SET NEW.IncrementRate = 20.00;
    ELSEIF job_duration >= 1 AND (NEW.NoOfPub = 2 OR NEW.NoOfPub = 3) THEN
        SET NEW.IncrementRate = 10.00;
    ELSEIF job_duration >= 1 AND NEW.NoOfPub = 1 THEN
        SET NEW.IncrementRate = 5.00;
    ELSE
        SET NEW.IncrementRate = 0.00;
    END IF;
    
    SET NEW.UpdatedSalary = OLD.BasicSalary + (OLD.BasicSalary * (NEW.IncrementRate / 100));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_log_salary_change` AFTER UPDATE ON `employee` FOR EACH ROW BEGIN
    IF OLD.UpdatedSalary != NEW.UpdatedSalary OR (OLD.UpdatedSalary IS NULL AND NEW.UpdatedSalary IS NOT NULL) THEN
        INSERT INTO SALARY_LOG (EmpID, OldSalary, NewSalary, Note)
        VALUES (NEW.EmpID, OLD.BasicSalary, NEW.UpdatedSalary, CONCAT('Increment of ', NEW.IncrementRate, '% applied'));
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `salary_log`
--

CREATE TABLE `salary_log` (
  `LogID` int(11) NOT NULL,
  `EmpID` int(11) DEFAULT NULL,
  `OldSalary` decimal(10,2) DEFAULT NULL,
  `NewSalary` decimal(10,2) DEFAULT NULL,
  `ChangedAt` datetime DEFAULT current_timestamp(),
  `Note` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `salary_log`
--

INSERT INTO `salary_log` (`LogID`, `EmpID`, `OldSalary`, `NewSalary`, `ChangedAt`, `Note`) VALUES
(1, 101, 50000.00, 60000.00, '2026-04-13 21:01:17', 'Increment of 20.00% applied'),
(2, 102, 45000.00, 49500.00, '2026-04-13 21:01:17', 'Increment of 10.00% applied'),
(3, 103, 60000.00, 63000.00, '2026-04-13 21:01:17', 'Increment of 5.00% applied'),
(4, 104, 40000.00, 48000.00, '2026-04-13 21:01:17', 'Increment of 20.00% applied');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`EmpID`);

--
-- Indexes for table `salary_log`
--
ALTER TABLE `salary_log`
  ADD PRIMARY KEY (`LogID`),
  ADD KEY `EmpID` (`EmpID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `salary_log`
--
ALTER TABLE `salary_log`
  MODIFY `LogID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `salary_log`
--
ALTER TABLE `salary_log`
  ADD CONSTRAINT `salary_log_ibfk_1` FOREIGN KEY (`EmpID`) REFERENCES `employee` (`EmpID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
