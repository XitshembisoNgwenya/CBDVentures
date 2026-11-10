-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
-- Public redacted copy: account identities, hashes, contact details and user activity/preferences removed.
-- For test evidence only; see docs/database-evidence/2026-11-10/README.md.
--
-- Host: localhost    Database: cbdventures_db
-- ------------------------------------------------------
-- Server version	8.0.46

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
-- Table structure for table `amenities`
--

DROP TABLE IF EXISTS `amenities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `amenities` (
  `amenity_id` bigint NOT NULL AUTO_INCREMENT,
  `category_id` bigint NOT NULL,
  `amenity_name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`amenity_id`),
  UNIQUE KEY `uq_amenities_name` (`amenity_name`),
  KEY `fk_amenities_categories` (`category_id`),
  CONSTRAINT `fk_amenities_categories` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amenities`
--

LOCK TABLES `amenities` WRITE;
/*!40000 ALTER TABLE `amenities` DISABLE KEYS */;
INSERT INTO `amenities` VALUES (1,1,'Free Wi-Fi','High-speed fiber internet access',1),(2,1,'Loadshedding Backup Power','Inverters and generators active during power outages',1),(3,2,'Outdoor Seating','Al fresco dining options',1),(4,3,'Student Discount','Discounts available upon showing student card',1),(5,4,'Wheelchair Accessible','Ramps and accessible facilities',1);
/*!40000 ALTER TABLE `amenities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `business_amenities`
--

DROP TABLE IF EXISTS `business_amenities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `business_amenities` (
  `business_id` bigint NOT NULL,
  `amenity_id` bigint NOT NULL,
  PRIMARY KEY (`business_id`,`amenity_id`),
  KEY `fk_ba_amenities` (`amenity_id`),
  CONSTRAINT `fk_ba_amenities` FOREIGN KEY (`amenity_id`) REFERENCES `amenities` (`amenity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ba_businesses` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_amenities`
--

LOCK TABLES `business_amenities` WRITE;
/*!40000 ALTER TABLE `business_amenities` DISABLE KEYS */;
INSERT INTO `business_amenities` VALUES (1,1),(3,1),(4,1),(5,1),(8,1),(2,3),(8,4),(3,5),(12,5),(15,5);
/*!40000 ALTER TABLE `business_amenities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `business_hours`
--

DROP TABLE IF EXISTS `business_hours`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `business_hours` (
  `business_hours_id` bigint NOT NULL AUTO_INCREMENT,
  `business_id` bigint NOT NULL,
  `day_of_week` char(9) NOT NULL,
  `open_time` time DEFAULT NULL,
  `close_time` time DEFAULT NULL,
  `closed` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`business_hours_id`),
  KEY `fk_bh_businesses` (`business_id`),
  CONSTRAINT `fk_bh_businesses` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_hours`
--

LOCK TABLES `business_hours` WRITE;
/*!40000 ALTER TABLE `business_hours` DISABLE KEYS */;
INSERT INTO `business_hours` VALUES (1,1,'Monday','08:30:00','18:00:00',0),(2,1,'Tuesday','08:30:00','18:00:00',0),(3,1,'Wednesday','08:30:00','18:00:00',0),(4,1,'Thursday','08:30:00','18:00:00',0),(5,1,'Friday','08:30:00','18:00:00',0),(6,1,'Saturday','08:30:00','16:30:00',0),(7,1,'Sunday','09:00:00','15:00:00',0),(8,2,'Monday','07:00:00','22:00:00',0),(9,2,'Tuesday','07:00:00','22:00:00',0),(10,2,'Wednesday','07:00:00','22:00:00',0),(11,2,'Thursday','07:00:00','22:00:00',0),(12,2,'Friday','07:00:00','22:00:00',0),(13,2,'Saturday','07:00:00','22:00:00',0),(14,2,'Sunday','07:00:00','22:00:00',0),(15,3,'Monday','08:00:00','16:30:00',0),(16,3,'Tuesday','08:00:00','16:30:00',0),(17,3,'Wednesday','08:00:00','16:30:00',0),(18,3,'Thursday','08:00:00','16:30:00',0),(19,3,'Friday','08:00:00','16:00:00',0),(20,3,'Saturday','08:30:00','12:30:00',0),(21,3,'Sunday','00:00:00','00:00:00',1),(22,15,'Monday','08:00:00','17:00:00',0),(23,15,'Tuesday','08:00:00','17:00:00',0),(24,15,'Wednesday','08:00:00','17:00:00',0),(25,15,'Thursday','08:00:00','17:00:00',0),(26,15,'Friday','08:00:00','17:00:00',0),(27,15,'Saturday','08:30:00','13:00:00',0),(28,15,'Sunday','00:00:00','00:00:00',1);
/*!40000 ALTER TABLE `business_hours` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `business_images`
--

DROP TABLE IF EXISTS `business_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `business_images` (
  `image_id` bigint NOT NULL AUTO_INCREMENT,
  `business_id` bigint NOT NULL,
  `image_url` varchar(255) NOT NULL,
  `is_primary` tinyint(1) NOT NULL DEFAULT '0',
  `uploaded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`image_id`),
  KEY `fk_images_businesses` (`business_id`),
  CONSTRAINT `fk_images_businesses` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_images`
--

LOCK TABLES `business_images` WRITE;
/*!40000 ALTER TABLE `business_images` DISABLE KEYS */;
INSERT INTO `business_images` VALUES (1,1,'https://images.cbdventures.co.za/salons/sa_queen.jpg',1,'2026-11-10 09:24:53'),(2,2,'https://images.cbdventures.co.za/dining/black_bistro.jpg',1,'2026-11-10 09:24:53'),(3,3,'https://images.cbdventures.co.za/public/eskia_library.jpg',1,'2026-11-10 09:24:53'),(4,4,'https://images.cbdventures.co.za/cafes/asian_delight.jpg',1,'2026-11-10 09:24:53'),(5,5,'https://images.cbdventures.co.za/cafes/quick_bake.jpg',1,'2026-11-10 09:24:53'),(6,8,'https://images.cbdventures.co.za/cafes/xpresso_cafe.jpg',1,'2026-11-10 09:24:53'),(7,14,'https://images.cbdventures.co.za/fastfood/thuba_rush.jpg',1,'2026-11-10 09:24:53'),(8,15,'https://images.cbdventures.co.za/public/national_library.jpg',1,'2026-11-10 09:24:53');
/*!40000 ALTER TABLE `business_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `businesses`
--

DROP TABLE IF EXISTS `businesses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `businesses` (
  `business_id` bigint NOT NULL AUTO_INCREMENT,
  `owner_id` bigint NOT NULL,
  `category_id` bigint NOT NULL,
  `name` varchar(150) NOT NULL,
  `description` text,
  `address` varchar(255) NOT NULL,
  `latitude` decimal(10,8) NOT NULL,
  `longitude` decimal(11,8) NOT NULL,
  `price_level` enum('R','RR','RRR') NOT NULL DEFAULT 'RR',
  `status` enum('PENDING','PUBLISHED','INACTIVE') NOT NULL DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `contact_phone` varchar(30) DEFAULT NULL,
  `contact_email` varchar(150) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`business_id`),
  KEY `fk_businesses_users` (`owner_id`),
  KEY `fk_businesses_categories` (`category_id`),
  CONSTRAINT `fk_businesses_categories` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_businesses_users` FOREIGN KEY (`owner_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `businesses`
--

LOCK TABLES `businesses` WRITE;
/*!40000 ALTER TABLE `businesses` DISABLE KEYS */;
INSERT INTO `businesses` VALUES (1,2,3,'SA Queen Hair & Beauty','Hair and beauty salon offering hair and nail services.','231 Church St, Pretoria Central, Pretoria, 0002, South Africa',-25.74657000,28.18920000,'R','PUBLISHED','2026-11-10 09:24:53',NULL,NULL,'2026-11-10 09:24:53'),(2,2,2,'Black Bistro Lounge & Cocktail Kitchen','Bistro and cocktail kitchen serving meals and drinks at the South African State Theatre.','Drama Theatre Entrance, 320 Pretorius St, Pretoria Central, 0002, South Africa',-25.74676000,28.19472000,'RR','PUBLISHED','2026-11-10 09:24:53',NULL,NULL,'2026-11-10 09:24:53'),(3,2,4,'Es\'kia Mphahlele Community Library','Public library providing reading, research and information services.','347 Madiba St, Pretoria Central, Pretoria, 0002, South Africa',-25.74462960,28.19489150,'R','PUBLISHED','2026-11-10 09:24:53',NULL,NULL,'2026-11-10 09:24:53'),(4,2,1,'Asian Delight Shawarma','Shawarma, chip rolls, and halal fast food takeaways.','223 Central St, Pretoria Central, Pretoria, 0002, South Africa',-25.74681000,28.19214300,'R','PUBLISHED','2026-11-10 09:24:53',NULL,NULL,'2026-11-10 09:24:53'),(5,2,1,'Quick Bake','Confectionery, bakery items, coffee, and quick snacks.','7 Bank Ln, Pretoria Central, Pretoria, 0002, South Africa',-25.74890600,28.19221800,'R','PUBLISHED','2026-11-10 09:24:53',NULL,NULL,'2026-11-10 09:24:53'),(6,2,1,'Phola Shisa Nyama','Traditional shisa nyama and grilled meats.','219 Pretorius St, Pretoria Central, Pretoria, 0002, South Africa',-25.74799600,28.18922900,'RR','PUBLISHED','2026-11-10 09:24:53',NULL,NULL,'2026-11-10 09:24:53'),(7,2,1,'Top Class Fast Foods','Fast food takeaways, spathlos, and local meals.','287 Pretorius St, Pretoria Central, Pretoria, 0002, South Africa',-25.74753900,28.19260000,'R','PUBLISHED','2026-11-10 09:24:53',NULL,NULL,'2026-11-10 09:24:53'),(8,2,1,'Xpresso Café','South Africa\'s best priced coffee shop serving coffee, pastries, and beverages.','Pretoria Central, Pretoria, 0002, South Africa',-25.74570500,28.19005700,'R','PUBLISHED','2026-11-10 09:24:53',NULL,NULL,'2026-11-10 09:24:53'),(9,2,5,'Four Four Two Sports & Music Lounge','Sports bar, music lounge, and entertainment venue.','Pretoria Central, Pretoria, 0002, South Africa',-25.74583100,28.19756500,'RR','PUBLISHED','2026-11-10 09:24:53',NULL,NULL,'2026-11-10 09:24:53'),(10,2,1,'Honchos','Flame-grilled chicken, burgers, and family meals.','225 Pretorius St, Pretoria Central, Pretoria, 0002, South Africa',-25.74786400,28.18927700,'R','PUBLISHED','2026-11-10 09:24:53',NULL,NULL,'2026-11-10 09:24:53'),(11,2,1,'Family Chips & Rebels Pizza','Traditional takeaways, chips, pizza, and soft serve ice cream.','207 Pretorius St, Pretoria Central, Pretoria, 0002, South Africa',-25.74802600,28.18862900,'R','PUBLISHED','2026-11-10 09:24:53',NULL,NULL,'2026-11-10 09:24:53'),(12,2,3,'Absa Bank (ABSA Towers)','Commercial banking services, ATM, and foreign exchange.','230 Lilian Ngoyi St, Pretoria Central, Pretoria, 0002, South Africa',-25.74600000,28.19250000,'RR','PUBLISHED','2026-11-10 09:24:53',NULL,NULL,'2026-11-10 09:24:53'),(13,2,1,'Magwinya Zone','Fresh traditional magwinya, platters, and fast-casual combos.','Middestad Mall, Pretoria Central, Pretoria, 0002, South Africa',-25.74800000,28.19050000,'R','PUBLISHED','2026-11-10 09:24:53',NULL,NULL,'2026-11-10 09:24:53'),(14,2,1,'Thuba Rush KJ','Popular local kota joint, fast foods, and daily meals.','Live Easy Opera Plaza, 230 Pretorius St, Pretoria Central, Pretoria, 0002, South Africa',-25.74749100,28.18961000,'R','PUBLISHED','2026-11-10 09:24:53',NULL,NULL,'2026-11-10 09:24:53'),(15,2,4,'National Library of South Africa (Pretoria Campus)','National reference library providing extensive research archives, reading rooms, and study spaces.','228 Johannes Ramokhoase St, Pretoria Central, Pretoria, 0002, South Africa',-25.74315500,28.18950000,'R','PUBLISHED','2026-11-10 09:24:53',NULL,NULL,'2026-11-10 09:24:53');
/*!40000 ALTER TABLE `businesses` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_business_within_1km_insert` BEFORE INSERT ON `businesses` FOR EACH ROW BEGIN
    IF ST_Distance_Sphere(
        POINT(NEW.longitude, NEW.latitude),
        POINT(28.192483, -25.746400)
    ) > 1000 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Business location must be within 1 km of Richfield Pretoria Campus.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_business_within_1km_update` BEFORE UPDATE ON `businesses` FOR EACH ROW BEGIN
    IF ST_Distance_Sphere(
        POINT(NEW.longitude, NEW.latitude),
        POINT(28.192483, -25.746400)
    ) > 1000 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Business location must be within 1 km of Richfield Pretoria Campus.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `category_id` bigint NOT NULL AUTO_INCREMENT,
  `category_name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `uq_categories_name` (`category_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Cafes & Fast Food','Takeaways, bakeries, coffee shops, and quick bites',1),(2,'Restaurants & Dining','Casual and fine dining experiences across Pretoria CBD',1),(3,'Student Hubs & Services','Libraries, co-working spaces, study lounges, and banking',1),(4,'Public Facilities & Libraries','Civic services, municipal offices, and learning hubs',1),(5,'Entertainment & Nightlife','Sports bars, music lounges, and social hubs',1);
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `event_id` bigint NOT NULL AUTO_INCREMENT,
  `business_id` bigint NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text,
  `venue` varchar(100) DEFAULT NULL,
  `event_date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `ticket_price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`event_id`),
  KEY `fk_events_businesses` (`business_id`),
  CONSTRAINT `fk_events_businesses` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
INSERT INTO `events` VALUES (1,8,'Student Morning Brew Discount','Special morning rates for student card holders.','Xpresso Cafe Pretoria Central','2026-11-15','07:30:00','10:00:00',0.00,'2026-11-10 09:24:53'),(2,9,'Weekend Sports Broadcast & Jam','Live football matches and local DJ lineup.','Four Four Two Lounge','2026-11-14','18:00:00','23:00:00',0.00,'2026-11-10 09:24:53');
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_event_future_insert` BEFORE INSERT ON `events` FOR EACH ROW BEGIN
    IF TIMESTAMP(NEW.event_date, NEW.start_time) <= CURRENT_TIMESTAMP THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Event start date and time must be in the future.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_event_future_update` BEFORE UPDATE ON `events` FOR EACH ROW BEGIN
    IF TIMESTAMP(NEW.event_date, NEW.start_time) <= CURRENT_TIMESTAMP THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'An event must have a future start date and time.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `review_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `business_id` bigint NOT NULL,
  `rating` tinyint DEFAULT NULL,
  `comment` text,
  `verified` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`review_id`),
  KEY `fk_reviews_users` (`user_id`),
  KEY `fk_reviews_businesses` (`business_id`),
  CONSTRAINT `fk_reviews_businesses` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_reviews_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `reviews_chk_1` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (1,3,3,5,'Great quiet study environment right at Sammy Marks Building.',1,'2026-11-10 09:24:53'),(2,3,8,5,'Best priced coffee in Pretoria CBD! Very affordable for students.',1,'2026-11-10 09:24:53'),(3,3,14,4,'Solid local kota joint at Opera Plaza.',1,'2026-11-10 09:24:53'),(4,3,15,5,'Incredible national library archive and excellent research space.',1,'2026-11-10 09:24:53');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_review_no_self_review` BEFORE INSERT ON `reviews` FOR EACH ROW BEGIN
    DECLARE v_owner_id BIGINT;

    SELECT owner_id
    INTO v_owner_id
    FROM businesses
    WHERE business_id = NEW.business_id;

    IF NEW.user_id = v_owner_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'Business owners cannot review their own business.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_review_24h_limit` BEFORE INSERT ON `reviews` FOR EACH ROW BEGIN
    IF EXISTS (
        SELECT 1
        FROM reviews AS r
        WHERE r.user_id = NEW.user_id
          AND r.business_id = NEW.business_id
          AND r.created_at >= CURRENT_TIMESTAMP - INTERVAL 24 HOUR
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
                'You cannot review the same business more than once within 24 hours.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `user_activity`
--

DROP TABLE IF EXISTS `user_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_activity` (
  `activity_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `business_id` bigint DEFAULT NULL,
  `event_id` bigint DEFAULT NULL,
  `activity_type` varchar(20) NOT NULL,
  `occurred_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`activity_id`),
  KEY `fk_ua_users` (`user_id`),
  KEY `fk_ua_businesses` (`business_id`),
  KEY `fk_ua_events` (`event_id`),
  CONSTRAINT `fk_ua_businesses` FOREIGN KEY (`business_id`) REFERENCES `businesses` (`business_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ua_events` FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ua_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_activity`
--

LOCK TABLES `user_activity` WRITE;
/*!40000 ALTER TABLE `user_activity` DISABLE KEYS */;
-- User activity and preference rows omitted from this public redacted copy.
/*!40000 ALTER TABLE `user_activity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_preference`
--

DROP TABLE IF EXISTS `user_preference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_preference` (
  `preference_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `preferred_price_level` enum('R','RR','RRR') NOT NULL DEFAULT 'RR',
  `distance` decimal(4,2) NOT NULL DEFAULT '5.00',
  `wifi_required` tinyint(1) NOT NULL DEFAULT '0',
  `power_required` tinyint(1) NOT NULL DEFAULT '0',
  `noise_level_preference` enum('LOW','MEDIUM','HIGH') NOT NULL DEFAULT 'MEDIUM',
  `student_discount_required` tinyint(1) NOT NULL DEFAULT '0',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`preference_id`),
  KEY `fk_up_users` (`user_id`),
  CONSTRAINT `fk_up_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_preference`
--

LOCK TABLES `user_preference` WRITE;
/*!40000 ALTER TABLE `user_preference` DISABLE KEYS */;
-- User activity and preference rows omitted from this public redacted copy.
/*!40000 ALTER TABLE `user_preference` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_preference_category`
--

DROP TABLE IF EXISTS `user_preference_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_preference_category` (
  `preference_id` bigint NOT NULL,
  `category_id` bigint NOT NULL,
  PRIMARY KEY (`preference_id`,`category_id`),
  KEY `fk_upc_category` (`category_id`),
  CONSTRAINT `fk_upc_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_upc_preference` FOREIGN KEY (`preference_id`) REFERENCES `user_preference` (`preference_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_preference_category`
--

LOCK TABLES `user_preference_category` WRITE;
/*!40000 ALTER TABLE `user_preference_category` DISABLE KEYS */;
-- User activity and preference rows omitted from this public redacted copy.
/*!40000 ALTER TABLE `user_preference_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` bigint NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('VISITOR','OWNER','ADMIN') NOT NULL DEFAULT 'VISITOR',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `account_status` enum('ACTIVE','SUSPENDED') NOT NULL DEFAULT 'ACTIVE',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uq_users_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Demo Owner One','owner.one@example.invalid','REDACTED_NOT_A_LOGIN_HASH','OWNER','2026-11-10 09:24:53','ACTIVE','2026-11-10 09:24:53'),(2,'Demo Owner Two','owner.two@example.invalid','REDACTED_NOT_A_LOGIN_HASH','OWNER','2026-11-10 09:24:53','ACTIVE','2026-11-10 09:24:53'),(3,'Demo Visitor One','visitor.one@example.invalid','REDACTED_NOT_A_LOGIN_HASH','VISITOR','2026-11-10 09:24:53','ACTIVE','2026-11-10 09:24:53'),(4,'Demo Admin','admin@example.invalid','REDACTED_NOT_A_LOGIN_HASH','ADMIN','2026-11-10 09:24:53','ACTIVE','2026-11-10 09:24:53'),(5,'Demo Visitor Two','visitor.two@example.invalid','REDACTED_NOT_A_LOGIN_HASH','VISITOR','2026-11-10 09:24:53','ACTIVE','2026-11-10 09:24:53');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_business_directory`
--

DROP TABLE IF EXISTS `vw_business_directory`;
/*!50001 DROP VIEW IF EXISTS `vw_business_directory`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_business_directory` AS SELECT 
 1 AS `business_id`,
 1 AS `business_name`,
 1 AS `category_name`,
 1 AS `description`,
 1 AS `address`,
 1 AS `latitude`,
 1 AS `longitude`,
 1 AS `price_level`,
 1 AS `status`,
 1 AS `contact_phone`,
 1 AS `contact_email`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'cbdventures_db'
--

--
-- Dumping routines for database 'cbdventures_db'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_businesses_in_radius` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_businesses_in_radius`(
    IN user_lat DECIMAL(10, 8),
    IN user_lng DECIMAL(11, 8),
    IN radius_km DECIMAL(5, 2)
)
BEGIN
    SELECT 
        b.business_id,
        b.business_name,
        c.category_name,
        b.price_level,
        b.address,
        b.latitude,
        b.longitude,
        ( 6371 * acos( 
            cos( radians(user_lat) ) 
            * cos( radians( b.latitude ) ) 
            * cos( radians( b.longitude ) - radians(user_lng) ) 
            + sin( radians(user_lat) ) 
            * sin( radians( b.latitude ) ) 
        ) ) AS distance_in_km
    FROM businesses b
    JOIN categories c ON b.category_id = c.category_id
    HAVING distance_in_km <= radius_km
    ORDER BY distance_in_km ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `vw_business_directory`
--

/*!50001 DROP VIEW IF EXISTS `vw_business_directory`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_business_directory` AS select `b`.`business_id` AS `business_id`,`b`.`name` AS `business_name`,`c`.`category_name` AS `category_name`,`b`.`description` AS `description`,`b`.`address` AS `address`,`b`.`latitude` AS `latitude`,`b`.`longitude` AS `longitude`,`b`.`price_level` AS `price_level`,`b`.`status` AS `status`,`b`.`contact_phone` AS `contact_phone`,`b`.`contact_email` AS `contact_email` from (`businesses` `b` join `categories` `c` on((`b`.`category_id` = `c`.`category_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-10 11:41:41
