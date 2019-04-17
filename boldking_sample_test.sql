# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.22)
# Database: boldking_sample_test
# Generation Time: 2019-04-17 09:42:38 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table Customers
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Customers`;

CREATE TABLE `Customers` (
  `id` int(6) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `email` varchar(50) DEFAULT NULL,
  `subscriptions` int(30) DEFAULT NULL,
  `active` enum('y','n') DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `Customers` WRITE;
/*!40000 ALTER TABLE `Customers` DISABLE KEYS */;

INSERT INTO `Customers` (`id`, `name`, `email`, `subscriptions`, `active`)
VALUES
	(1,'Bruce Wayne','bruce@boldking.com ',NULL,'y'),
	(2,'Diana Prince ','diana@boldking.com',1,'y'),
	(3,'Tony Stark ','tony@boldking.com ',2,'y'),
	(4,'Peter Parker ','peter@boldking.com ',3,'y');

/*!40000 ALTER TABLE `Customers` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table Delivery
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Delivery`;

CREATE TABLE `Delivery` (
  `id` int(6) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int(3) NOT NULL,
  `delivery_date` date DEFAULT NULL,
  `status` enum('pending','delivered') DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table Orders
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Orders`;

CREATE TABLE `Orders` (
  `id` int(6) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int(3) NOT NULL,
  `subscription_id` int(3) DEFAULT NULL,
  `status` enum('failed','paid','created') DEFAULT NULL,
  `total` int(3) DEFAULT NULL,
  `paid_date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `Orders` WRITE;
/*!40000 ALTER TABLE `Orders` DISABLE KEYS */;

INSERT INTO `Orders` (`id`, `customer_id`, `subscription_id`, `status`, `total`, `paid_date`)
VALUES
	(1,2,1,'failed',50,'2018-12-15'),
	(2,1,NULL,'paid',100,'2019-01-03'),
	(3,3,2,'paid',10,'2019-02-11'),
	(4,2,NULL,'paid',20,'2019-03-04'),
	(5,4,3,'created',30,'2019-03-06');

/*!40000 ALTER TABLE `Orders` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table Subscriptions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `Subscriptions`;

CREATE TABLE `Subscriptions` (
  `id` int(6) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int(3) NOT NULL,
  `start_date` date DEFAULT NULL,
  `nextorder_date` date DEFAULT NULL,
  `day_iteration` int(3) DEFAULT NULL,
  `active` enum('n','y') DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `Subscriptions` WRITE;
/*!40000 ALTER TABLE `Subscriptions` DISABLE KEYS */;

INSERT INTO `Subscriptions` (`id`, `customer_id`, `start_date`, `nextorder_date`, `day_iteration`, `active`)
VALUES
	(1,2,'2018-08-01','2019-02-02',30,'n'),
	(2,3,'2018-04-01','2019-03-21',40,'y'),
	(3,4,'2019-03-06','2019-03-26',20,'y');

/*!40000 ALTER TABLE `Subscriptions` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
