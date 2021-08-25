-- MySQL dump 10.13  Distrib 5.7.20, for Linux (x86_64)
--
-- Host: localhost    Database: Exercise1
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
-- Table structure for table `Coach`
--

DROP TABLE IF EXISTS `Coach`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Coach` (
  `cid` int(11) NOT NULL,
  `name` varchar(20) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `tid` int(11) DEFAULT NULL,
  `nationality` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`cid`),
  KEY `tid` (`tid`),
  CONSTRAINT `Coach_ibfk_1` FOREIGN KEY (`tid`) REFERENCES `Team` (`tid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Coach`
--

LOCK TABLES `Coach` WRITE;
/*!40000 ALTER TABLE `Coach` DISABLE KEYS */;
INSERT INTO `Coach` VALUES (1,'Arman Molaie',34,3,'Brazil'),(2,'Ali Amini',25,2,'Argentina'),(3,'Ehsan Tavakoli',31,4,'Iran'),(4,'Sina Rasooli',26,1,'Iran'),(5,'Arian Sheikhi',28,5,'Iran'),(6,'Hamed Kalimi',37,6,'Iran');
/*!40000 ALTER TABLE `Coach` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Game`
--

DROP TABLE IF EXISTS `Game`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Game` (
  `gid` int(11) NOT NULL,
  `date` date DEFAULT NULL,
  `ggoal` int(11) DEFAULT NULL,
  `hgoal` int(11) DEFAULT NULL,
  PRIMARY KEY (`gid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Game`
--

LOCK TABLES `Game` WRITE;
/*!40000 ALTER TABLE `Game` DISABLE KEYS */;
INSERT INTO `Game` VALUES (1,'2009-12-04',2,4),(2,'2014-03-04',3,0),(3,'2012-10-23',5,4),(4,'2014-03-04',1,0),(5,'2016-07-18',0,0);
/*!40000 ALTER TABLE `Game` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Game_rel`
--

DROP TABLE IF EXISTS `Game_rel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Game_rel` (
  `guest_tid` int(11) DEFAULT NULL,
  `host_tid` int(11) DEFAULT NULL,
  `gid` int(11) DEFAULT NULL,
  KEY `guest_tid` (`guest_tid`),
  KEY `host_tid` (`host_tid`),
  KEY `gid` (`gid`),
  CONSTRAINT `Game_rel_ibfk_1` FOREIGN KEY (`guest_tid`) REFERENCES `Team` (`tid`),
  CONSTRAINT `Game_rel_ibfk_2` FOREIGN KEY (`host_tid`) REFERENCES `Team` (`tid`),
  CONSTRAINT `Game_rel_ibfk_3` FOREIGN KEY (`gid`) REFERENCES `Game` (`gid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Game_rel`
--

LOCK TABLES `Game_rel` WRITE;
/*!40000 ALTER TABLE `Game_rel` DISABLE KEYS */;
INSERT INTO `Game_rel` VALUES (3,1,1),(1,3,2),(2,5,3),(4,3,4),(3,2,5);
/*!40000 ALTER TABLE `Game_rel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Injuries`
--

DROP TABLE IF EXISTS `Injuries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Injuries` (
  `date` date DEFAULT NULL,
  `pid` int(11) DEFAULT NULL,
  KEY `pid` (`pid`),
  CONSTRAINT `Injuries_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `Player` (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Injuries`
--

LOCK TABLES `Injuries` WRITE;
/*!40000 ALTER TABLE `Injuries` DISABLE KEYS */;
/*!40000 ALTER TABLE `Injuries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `League`
--

DROP TABLE IF EXISTS `League`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `League` (
  `year` year(4) NOT NULL,
  PRIMARY KEY (`year`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `League`
--

LOCK TABLES `League` WRITE;
/*!40000 ALTER TABLE `League` DISABLE KEYS */;
/*!40000 ALTER TABLE `League` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Playedin`
--

DROP TABLE IF EXISTS `Playedin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Playedin` (
  `pid` int(11) DEFAULT NULL,
  `tid` int(11) DEFAULT NULL,
  KEY `pid` (`pid`),
  KEY `tid` (`tid`),
  CONSTRAINT `Playedin_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `Player` (`pid`),
  CONSTRAINT `Playedin_ibfk_2` FOREIGN KEY (`tid`) REFERENCES `Team` (`tid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Playedin`
--

LOCK TABLES `Playedin` WRITE;
/*!40000 ALTER TABLE `Playedin` DISABLE KEYS */;
INSERT INTO `Playedin` VALUES (2,6),(1,6),(4,3),(3,5),(5,4);
/*!40000 ALTER TABLE `Playedin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Player`
--

DROP TABLE IF EXISTS `Player`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Player` (
  `pid` int(11) NOT NULL,
  `name` varchar(20) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `nationality` varchar(15) DEFAULT NULL,
  `role` varchar(15) DEFAULT NULL,
  `is_captain` tinyint(1) DEFAULT NULL,
  `being_in_national_team_status` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Player`
--

LOCK TABLES `Player` WRITE;
/*!40000 ALTER TABLE `Player` DISABLE KEYS */;
INSERT INTO `Player` VALUES (1,'Mehdi Mahdavikia',35,'Iran','Defender',1,1),(2,'Ali Karimi',31,'Iran','Midfielder',0,1),(3,'Alireza Haghighi',25,'Iran','Goalkeeper',0,0),(4,'Mehdi Bagheri',32,'Iran','Midfielder',1,1),(5,'Karim Ansari',23,'Iran','Forward',0,1);
/*!40000 ALTER TABLE `Player` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Team`
--

DROP TABLE IF EXISTS `Team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Team` (
  `tid` int(11) NOT NULL,
  `name` varchar(20) DEFAULT NULL,
  `country` varchar(15) DEFAULT NULL,
  `city` varchar(15) DEFAULT NULL,
  `score` int(11) DEFAULT NULL,
  `being_in_AFC_champions_league_status` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`tid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Team`
--

LOCK TABLES `Team` WRITE;
/*!40000 ALTER TABLE `Team` DISABLE KEYS */;
INSERT INTO `Team` VALUES (1,'Perspolis','Iran','Tehran',25,1),(2,'Esteghlal','Iran','Tehran',23,1),(3,'Saipa','Iran','Karaj',17,0),(4,'Sepahan','Iran','Isfahan',18,1),(5,'Zobahan','Iran','Isfahan',20,1),(6,'Sepidrood','Iran','Gilan',14,0);
/*!40000 ALTER TABLE `Team` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-03-16 23:32:32
