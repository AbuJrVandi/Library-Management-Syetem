-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: librarydb
-- ------------------------------------------------------
-- Server version	8.0.37

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books` (
  `BookID` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(255) NOT NULL,
  `Author` varchar(255) NOT NULL,
  `ISBN` varchar(20) NOT NULL,
  `Status` enum('Available','Checked Out') DEFAULT 'Available',
  PRIMARY KEY (`BookID`),
  UNIQUE KEY `ISBN` (`ISBN`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (1,'The Great Gatsby','F. Scott Fitzgerald','9780743273565','Available'),(2,'1984','George Orwell','9780451524935','Available'),(3,'To Kill a Mockingbird','Harper Lee','9780060935467','Available');
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `checkedoutbooks`
--

DROP TABLE IF EXISTS `checkedoutbooks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `checkedoutbooks` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `BookID` int DEFAULT NULL,
  `PatronID` int DEFAULT NULL,
  `CheckoutDate` date DEFAULT NULL,
  `DueDate` date DEFAULT NULL,
  `Fine` decimal(5,2) DEFAULT '0.00',
  PRIMARY KEY (`ID`),
  KEY `BookID` (`BookID`),
  KEY `PatronID` (`PatronID`),
  CONSTRAINT `checkedoutbooks_ibfk_1` FOREIGN KEY (`BookID`) REFERENCES `books` (`BookID`),
  CONSTRAINT `checkedoutbooks_ibfk_2` FOREIGN KEY (`PatronID`) REFERENCES `patrons` (`PatronID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checkedoutbooks`
--

LOCK TABLES `checkedoutbooks` WRITE;
/*!40000 ALTER TABLE `checkedoutbooks` DISABLE KEYS */;
/*!40000 ALTER TABLE `checkedoutbooks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patrons`
--

DROP TABLE IF EXISTS `patrons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patrons` (
  `PatronID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `LibraryCardNumber` varchar(20) NOT NULL,
  PRIMARY KEY (`PatronID`),
  UNIQUE KEY `LibraryCardNumber` (`LibraryCardNumber`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patrons`
--

LOCK TABLES `patrons` WRITE;
/*!40000 ALTER TABLE `patrons` DISABLE KEYS */;
INSERT INTO `patrons` VALUES (1,'John Doe','LC123456'),(2,'Jane Smith','LC789012');
/*!40000 ALTER TABLE `patrons` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-25 10:27:01
