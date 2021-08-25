-- MySQL dump 10.13  Distrib 5.7.20, for Linux (x86_64)
--
-- Host: localhost    Database: Exe3
-- ------------------------------------------------------
-- Server version	5.7.21-0ubuntu0.17.10.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Artist`
--

DROP TABLE IF EXISTS `Artist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Artist` (
  `aid` varchar(5) NOT NULL,
  `name` varchar(20) DEFAULT NULL,
  `country` varchar(15) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`aid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Artist`
--

LOCK TABLES `Artist` WRITE;
/*!40000 ALTER TABLE `Artist` DISABLE KEYS */;
/*!40000 ALTER TABLE `Artist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Attended`
--

DROP TABLE IF EXISTS `Attended`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Attended` (
  `auid` varchar(5) DEFAULT NULL,
  `cid` varchar(5) DEFAULT NULL,
  KEY `auid` (`auid`),
  KEY `cid` (`cid`),
  CONSTRAINT `Attended_ibfk_1` FOREIGN KEY (`auid`) REFERENCES `Audience` (`auid`),
  CONSTRAINT `Attended_ibfk_2` FOREIGN KEY (`cid`) REFERENCES `Concert` (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Attended`
--

LOCK TABLES `Attended` WRITE;
/*!40000 ALTER TABLE `Attended` DISABLE KEYS */;
/*!40000 ALTER TABLE `Attended` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Audience`
--

DROP TABLE IF EXISTS `Audience`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Audience` (
  `auid` varchar(5) NOT NULL,
  `full_name` varchar(20) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`auid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Audience`
--

LOCK TABLES `Audience` WRITE;
/*!40000 ALTER TABLE `Audience` DISABLE KEYS */;
/*!40000 ALTER TABLE `Audience` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Concert`
--

DROP TABLE IF EXISTS `Concert`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Concert` (
  `cid` varchar(5) NOT NULL,
  `location` varchar(200) DEFAULT NULL,
  `ticket_price` int(11) DEFAULT NULL,
  `year` year(4) DEFAULT NULL,
  PRIMARY KEY (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Concert`
--

LOCK TABLES `Concert` WRITE;
/*!40000 ALTER TABLE `Concert` DISABLE KEYS */;
/*!40000 ALTER TABLE `Concert` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Playedin`
--

DROP TABLE IF EXISTS `Playedin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Playedin` (
  `sid` varchar(5) DEFAULT NULL,
  `cid` varchar(5) DEFAULT NULL,
  KEY `sid` (`sid`),
  KEY `cid` (`cid`),
  CONSTRAINT `Playedin_ibfk_1` FOREIGN KEY (`sid`) REFERENCES `Song` (`sid`),
  CONSTRAINT `Playedin_ibfk_2` FOREIGN KEY (`cid`) REFERENCES `Concert` (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Playedin`
--

LOCK TABLES `Playedin` WRITE;
/*!40000 ALTER TABLE `Playedin` DISABLE KEYS */;
/*!40000 ALTER TABLE `Playedin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Song`
--

DROP TABLE IF EXISTS `Song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Song` (
  `sid` varchar(5) NOT NULL,
  `title` varchar(20) DEFAULT NULL,
  `aid` varchar(5) DEFAULT NULL,
  `genre` varchar(15) DEFAULT NULL,
  `duration` time DEFAULT NULL,
  PRIMARY KEY (`sid`),
  KEY `aid` (`aid`),
  CONSTRAINT `Song_ibfk_1` FOREIGN KEY (`aid`) REFERENCES `Artist` (`aid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Song`
--

LOCK TABLES `Song` WRITE;
/*!40000 ALTER TABLE `Song` DISABLE KEYS */;
/*!40000 ALTER TABLE `Song` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-03-16 19:51:25
