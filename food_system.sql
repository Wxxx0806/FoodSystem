-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: food-system
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `dish`
--

DROP TABLE IF EXISTS `dish`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dish` (
                        `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
                        `name` varchar(32) COLLATE utf8mb3_bin NOT NULL COMMENT '菜品名称',
                        `category_id` bigint NOT NULL COMMENT '菜品分类id',
                        `price` decimal(10,2) DEFAULT NULL COMMENT '菜品价格',
                        `image` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '图片',
                        `description` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '描述信息',
                        `status` int DEFAULT '1' COMMENT '0 停售 1 起售',
                        `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                        `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                        `stock` int NOT NULL DEFAULT '0' COMMENT '库存数量',
                        `locked_stock` int NOT NULL DEFAULT '0' COMMENT '锁定库存（预减）',
                        PRIMARY KEY (`id`),
                        UNIQUE KEY `idx_dish_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='菜品';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dish`
--

LOCK TABLES `dish` WRITE;
/*!40000 ALTER TABLE `dish` DISABLE KEYS */;
INSERT INTO `dish` VALUES (76,'鱼香肉丝',1,22.00,'/img/dish2.jpg','酸甜可口',1,'2025-12-11 18:09:38','2026-01-14 14:44:24',63,63),(77,'麻婆豆腐',1,18.00,'/img/dish3.jpg','麻辣鲜香',1,'2025-12-11 18:09:38','2025-12-11 18:09:38',0,0),(78,'红烧肉',2,32.00,'/img/dish4.jpg','肥而不腻',1,'2025-12-11 18:09:38','2025-12-11 18:09:38',11,11),(79,'蒜蓉生菜',3,12.00,'/img/dish5.jpg','清爽美味',1,'2025-12-11 18:09:38','2025-12-11 18:09:38',3,3),(80,'可乐鸡翅',2,28.00,'/img/dish6.jpg','孩子最爱',1,'2025-12-11 18:09:38','2025-12-11 18:09:38',5,5),(83,'水煮鱼',1,48.00,'/img/dish9.jpg','麻辣鲜香',1,'2025-12-11 18:09:38','2025-12-11 18:09:38',60,60),(85,'烤鸡腿',2,30.00,'/img/dish11.jpg','鲜嫩多汁',1,'2025-12-11 18:09:38','2025-12-11 18:09:38',94,95),(86,'孜然羊肉',2,36.00,'/img/dish12.jpg','孜然香味浓郁',1,'2025-12-11 18:09:38','2025-12-11 18:09:38',70,70),(87,'香辣虾',2,42.00,'/img/dish13.jpg','香辣开胃',1,'2025-12-11 18:09:38','2025-12-11 18:09:38',76,76),(88,'清蒸鲈鱼',3,55.00,'/img/dish14.jpg','鲜嫩可口',1,'2025-12-11 18:09:38','2025-12-11 18:09:38',39,-1),(89,'凉拌黄瓜',3,10.00,'/img/dish15.jpg','清爽解腻',1,'2025-12-11 18:09:38','2025-12-11 18:09:38',4,6),(90,'紫菜蛋花汤',4,8.00,'/img/dish16.jpg','清淡营养',1,'2025-12-11 18:09:38','2025-12-11 18:09:38',5,10),(91,'排骨汤',4,35.00,'/img/dish17.jpg','滋补好喝',1,'2025-12-11 18:09:38','2025-12-11 18:09:38',60,3),(92,'炒饭',5,15.00,'/img/dish18.jpg','方便快捷',1,'2025-12-11 18:09:38','2025-12-11 18:09:38',20,10),(93,'牛肉面',5,20.00,'/img/dish19.jpg','汤浓味足',1,'2025-12-11 18:09:38','2025-12-11 18:09:38',18,5),(94,'担担面',5,18.00,'/img/dish20.jpg','四川特色',1,'2025-12-11 18:09:38','2025-12-11 18:09:38',90,3),(95,'香菇滑鸡',1,27.00,'/img/dish21.jpg','入味鲜香',1,'2025-12-11 18:09:38','2025-12-11 18:09:38',80,4),(96,'香辣炒田螺',1,31.00,'/img/dish22.jpg','夜宵必点',1,'2025-12-11 18:09:38','2025-12-11 18:41:51',50,1),(98,'椒盐排条',2,34.00,'/img/dish24.jpg','酥脆鲜香',1,'2025-12-11 18:09:38','2025-12-11 18:09:38',70,2),(99,'黑椒牛排',2,58.00,'/img/dish25.jpg','西式料理',1,'2025-12-11 18:09:38','2025-12-11 18:09:38',55,3),(100,'烤鸭',2,55.00,'','',1,'2025-12-16 17:41:59','2026-01-14 14:44:17',11,11);
/*!40000 ALTER TABLE `dish` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
                            `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
                            `name` varchar(32) COLLATE utf8mb3_bin NOT NULL COMMENT '姓名',
                            `username` varchar(32) COLLATE utf8mb3_bin NOT NULL COMMENT '用户名',
                            `password` varchar(64) COLLATE utf8mb3_bin NOT NULL COMMENT '密码',
                            `phone` varchar(11) COLLATE utf8mb3_bin NOT NULL COMMENT '手机号',
                            `sex` varchar(2) COLLATE utf8mb3_bin NOT NULL COMMENT '性别',
                            `id_number` varchar(18) COLLATE utf8mb3_bin NOT NULL COMMENT '身份证号',
                            `status` int NOT NULL DEFAULT '1' COMMENT '状态 0:禁用，1:启用',
                            `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                            `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                            `create_user` bigint DEFAULT NULL COMMENT '创建人',
                            `update_user` bigint DEFAULT NULL COMMENT '修改人',
                            PRIMARY KEY (`id`),
                            UNIQUE KEY `idx_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='员工信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES (1,'管理员','admin','123456','13700001111','男','110101198505053456',1,'2025-11-18 16:18:22','2025-11-18 16:18:22',NULL,NULL),(2,'赵店员','staff','$2a$10$Lc0yK8S5dM1HxT9vJnRq.eWvLqJ7E6iXwU2bN3mZ4nO5pQ6rS7tU8','13611112222','女','110101199506064567',0,'2025-11-18 16:18:22','2025-11-19 22:51:59',NULL,1),(8,'王小明','wangxiaoming','123456','13812345678','男','110105199503071234',0,'2025-11-21 22:06:13','2026-01-14 14:44:45',1,1);
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_detail`
--

DROP TABLE IF EXISTS `order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_detail` (
                                `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
                                `name` varchar(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '名字',
                                `image` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '图片',
                                `order_id` bigint NOT NULL COMMENT '订单id',
                                `dish_id` bigint DEFAULT NULL COMMENT '菜品id',
                                `number` int NOT NULL DEFAULT '1' COMMENT '数量',
                                `amount` decimal(10,2) NOT NULL COMMENT '金额',
                                `price` decimal(10,2) NOT NULL DEFAULT '0.00',
                                `subtotal` decimal(10,2) NOT NULL DEFAULT '0.00',
                                PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='订单明细表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_detail`
--

LOCK TABLES `order_detail` WRITE;
/*!40000 ALTER TABLE `order_detail` DISABLE KEYS */;
INSERT INTO `order_detail` VALUES (1,'宫保鸡丁','https://example.com/dish/gongbao.jpg',1,1,1,28.00,0.00,0.00),(2,'麻婆豆腐','https://example.com/dish/mapo.jpg',1,3,1,18.00,0.00,0.00),(3,'清炒时蔬','https://example.com/dish/veggie.jpg',1,4,1,12.00,0.00,0.00),(4,'鱼香肉丝','https://example.com/dish/yuxiang.jpg',2,2,2,44.00,0.00,0.00),(5,'宫保鸡丁（升级）',NULL,3,1,2,30.00,0.00,0.00),(6,'鱼香肉丝',NULL,3,2,1,22.00,0.00,0.00),(7,'宫保鸡丁（升级）',NULL,4,1,2,30.00,0.00,0.00),(8,'鱼香肉丝',NULL,4,2,1,22.00,0.00,0.00),(9,'宫保鸡丁（升级）',NULL,5,1,2,30.00,0.00,0.00),(10,'鱼香肉丝','https://example.com/dish/yuxiang.jpg',5,2,1,22.00,0.00,0.00),(11,'宫保鸡丁（升级）',NULL,7,1,2,30.00,0.00,0.00),(12,'鱼香肉丝','https://example.com/dish/yuxiang.jpg',7,2,1,22.00,0.00,0.00),(13,'宫保鸡丁（升级）',NULL,8,1,2,30.00,0.00,0.00),(14,'鱼香肉丝','https://example.com/dish/yuxiang.jpg',8,2,1,22.00,0.00,0.00),(15,'宫保鸡丁（升级）',NULL,9,1,2,30.00,0.00,0.00),(16,'鱼香肉丝','https://example.com/dish/yuxiang.jpg',9,2,1,22.00,0.00,0.00),(17,'宫保鸡丁（升级）',NULL,10,1,3,30.00,0.00,0.00),(18,'鱼香肉丝','https://example.com/dish/yuxiang.jpg',10,2,2,22.00,0.00,0.00),(19,'宫保鸡丁（升级）',NULL,11,1,3,30.00,0.00,0.00),(20,'鱼香肉丝','https://example.com/dish/yuxiang.jpg',11,2,2,22.00,0.00,0.00),(21,'宫保鸡丁（升级）',NULL,12,1,1,30.00,0.00,0.00),(22,'宫保鸡','https://example.com/dish/gongbao.jpg',12,8,1,28.00,0.00,0.00),(23,'宫保鸡丁','/img/dish1.jpg',1,1,1,25.00,25.00,25.00),(24,'鱼香肉丝','/img/dish2.jpg',2,2,1,22.00,22.00,22.00),(25,'酸菜鱼','/img/dish23.jpg',3,23,1,46.00,46.00,46.00),(26,'炒饭','/img/dish18.jpg',4,18,1,15.00,15.00,15.00),(27,'牛肉面','/img/dish19.jpg',5,19,1,20.00,20.00,20.00),(28,'糖醋里脊','/img/dish8.jpg',6,8,1,26.00,26.00,26.00),(29,'香辣虾','/img/dish13.jpg',7,13,1,42.00,42.00,42.00),(30,'可乐鸡翅','/img/dish6.jpg',8,6,1,28.00,28.00,28.00),(31,'紫菜蛋花汤','/img/dish16.jpg',9,16,2,16.00,8.00,16.00),(32,'凉拌黄瓜','/img/dish15.jpg',10,15,1,10.00,10.00,10.00),(33,'红烧肉','/img/dish4.jpg',11,4,1,32.00,32.00,32.00),(34,'排骨汤','/img/dish17.jpg',12,17,1,35.00,35.00,35.00),(35,'麻婆豆腐','/img/dish3.jpg',13,3,2,36.00,18.00,36.00),(36,'小炒肉','/img/dish10.jpg',14,10,1,24.00,24.00,24.00),(37,'香菇滑鸡','/img/dish21.jpg',15,21,1,27.00,27.00,27.00),(38,'烤鸡腿','/img/dish11.jpg',16,11,1,30.00,30.00,30.00),(39,'担担面','/img/dish20.jpg',17,20,1,18.00,18.00,18.00),(40,'西红柿炒蛋','/img/dish7.jpg',18,7,1,15.00,15.00,15.00),(41,'椒盐排条','/img/dish24.jpg',19,24,1,34.00,34.00,34.00),(42,'清蒸鲈鱼','/img/dish14.jpg',20,14,1,55.00,55.00,55.00),(43,'孜然羊肉','/img/dish12.jpg',21,12,1,36.00,36.00,36.00),(44,'水煮鱼','/img/dish9.jpg',22,9,1,48.00,48.00,48.00),(45,'凉拌黄瓜','/img/dish15.jpg',23,15,1,10.00,10.00,10.00),(46,'酸菜鱼','/img/dish23.jpg',24,23,1,46.00,46.00,46.00),(47,'香辣炒田螺','/img/dish22.jpg',25,22,1,33.00,33.00,33.00),(48,'麻婆豆腐','/img/dish3.jpg',38,77,1,18.00,0.00,0.00),(49,'可乐鸡翅','/img/dish6.jpg',38,80,1,28.00,0.00,0.00),(50,'西红柿炒蛋','/img/dish7.jpg',38,81,1,15.00,0.00,0.00),(51,'小炒肉','/img/dish10.jpg',38,84,1,24.00,0.00,0.00),(52,'麻婆豆腐','/img/dish3.jpg',39,77,1,18.00,0.00,0.00),(53,'蒜蓉生菜','/img/dish5.jpg',39,79,1,12.00,0.00,0.00),(54,'可乐鸡翅','/img/dish6.jpg',39,80,1,28.00,0.00,0.00),(55,'糖醋里脊','/img/dish8.jpg',39,82,1,26.00,0.00,0.00),(56,'清蒸鲈鱼','/img/dish14.jpg',39,88,1,55.00,0.00,0.00),(57,'麻婆豆腐','/img/dish3.jpg',40,77,7,18.00,0.00,0.00),(58,'可乐鸡翅','/img/dish6.jpg',41,80,8,28.00,0.00,0.00),(59,'鱼香肉丝','/img/dish2.jpg',42,76,7,22.00,0.00,0.00),(60,'可乐鸡翅','/img/dish6.jpg',42,80,1,28.00,0.00,0.00),(61,'小炒肉','/img/dish10.jpg',42,84,9,24.00,0.00,0.00),(62,'香辣虾','/img/dish13.jpg',42,87,9,42.00,0.00,0.00),(63,'红烧肉','/img/dish4.jpg',43,78,1,32.00,0.00,0.00),(64,'西红柿炒蛋','/img/dish7.jpg',43,81,1,15.00,0.00,0.00),(65,'糖醋里脊','/img/dish8.jpg',43,82,1,26.00,0.00,0.00),(66,'小炒肉','/img/dish10.jpg',43,84,1,24.00,0.00,0.00),(67,'可乐鸡翅','/img/dish6.jpg',44,80,2,28.00,0.00,0.00),(68,'红烧肉','/img/dish4.jpg',45,78,2,32.00,0.00,0.00),(69,'蒜蓉生菜','/img/dish5.jpg',46,79,6,12.00,0.00,0.00),(70,'鱼香肉丝','/img/dish2.jpg',47,76,3,22.00,0.00,0.00),(71,'麻婆豆腐','/img/dish3.jpg',47,77,1,18.00,0.00,0.00),(72,'可乐鸡翅','/img/dish6.jpg',47,80,1,28.00,0.00,0.00),(73,'鱼香肉丝','/img/dish2.jpg',48,76,1,22.00,0.00,0.00),(74,'麻婆豆腐','/img/dish3.jpg',48,77,1,18.00,0.00,0.00),(75,'蒜蓉生菜','/img/dish5.jpg',48,79,1,12.00,0.00,0.00),(76,'烤鸡腿','/img/dish11.jpg',48,85,1,30.00,0.00,0.00),(77,'麻婆豆腐','/img/dish3.jpg',49,77,3,18.00,0.00,0.00),(78,'鱼香肉丝','/img/dish2.jpg',50,76,1,22.00,0.00,0.00),(79,'麻婆豆腐','/img/dish3.jpg',50,77,1,18.00,0.00,0.00),(80,'蒜蓉生菜','/img/dish5.jpg',50,79,5,12.00,0.00,0.00),(81,'鱼香肉丝','/img/dish2.jpg',51,76,2,22.00,0.00,0.00),(82,'麻婆豆腐','/img/dish3.jpg',51,77,3,18.00,0.00,0.00),(83,'蒜蓉生菜','/img/dish5.jpg',51,79,1,12.00,0.00,0.00),(84,'鱼香肉丝','/img/dish2.jpg',52,76,1,22.00,0.00,0.00),(85,'麻婆豆腐','/img/dish3.jpg',52,77,1,18.00,0.00,0.00),(86,'蒜蓉生菜','/img/dish5.jpg',52,79,1,12.00,0.00,0.00),(87,'可乐鸡翅','/img/dish6.jpg',52,80,1,28.00,0.00,0.00),(88,'麻婆豆腐','/img/dish3.jpg',53,77,3,18.00,0.00,0.00),(89,'鱼香肉丝','/img/dish2.jpg',54,76,1,22.00,0.00,0.00),(90,'鱼香肉丝','/img/dish2.jpg',55,76,4,22.00,0.00,0.00),(91,'麻婆豆腐','/img/dish3.jpg',55,77,1,18.00,0.00,0.00),(92,'鱼香肉丝','/img/dish2.jpg',56,76,2,22.00,0.00,0.00),(93,'鱼香肉丝','/img/dish2.jpg',57,76,2,22.00,0.00,0.00),(94,'麻婆豆腐','/img/dish3.jpg',57,77,1,18.00,0.00,0.00),(95,'蒜蓉生菜','/img/dish5.jpg',57,79,2,12.00,0.00,0.00),(96,'鱼香肉丝','/img/dish2.jpg',58,76,1,22.00,0.00,0.00),(97,'麻婆豆腐','/img/dish3.jpg',58,77,3,18.00,0.00,0.00),(98,'烤鸭','',58,100,1,55.00,0.00,0.00),(99,'鱼香肉丝','/img/dish2.jpg',59,76,2,22.00,0.00,0.00),(100,'烤鸭','',59,100,3,55.00,0.00,0.00);
/*!40000 ALTER TABLE `order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
                          `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
                          `number` varchar(50) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '订单号',
                          `status` int NOT NULL DEFAULT '0' COMMENT '0=待支付, 1=已支付, 2=已发货, 3=已完成, 4=已取消, 5=已退款',
                          `user_id` bigint NOT NULL COMMENT '下单用户',
                          `order_time` datetime NOT NULL COMMENT '下单时间',
                          `checkout_time` datetime DEFAULT NULL COMMENT '结账时间',
                          `pay_method` int NOT NULL DEFAULT '1' COMMENT '支付方式 1微信,2支付宝',
                          `pay_status` tinyint NOT NULL DEFAULT '0' COMMENT '支付状态 0未支付 1已支付 2退款',
                          `amount` decimal(10,2) NOT NULL COMMENT '实收金额',
                          `remark` varchar(100) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '备注',
                          `phone` varchar(11) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '手机号',
                          `user_name` varchar(32) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '用户名称',
                          `cancel_reason` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '订单取消原因',
                          `rejection_reason` varchar(255) COLLATE utf8mb3_bin DEFAULT NULL COMMENT '订单拒绝原因',
                          `cancel_time` datetime DEFAULT NULL COMMENT '订单取消时间',
                          `tableware_number` int DEFAULT NULL COMMENT '餐具数量',
                          `tableware_status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '餐具数量状态  1按餐量提供  0选择具体数量',
                          PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin COMMENT='订单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,'ORD202511180001',5,1,'2025-11-18 12:30:00','2025-11-18 12:35:00',1,1,50.00,'不要辣','13812345678','张三',NULL,NULL,NULL,2,0),(2,'ORD202511180002',1,2,'2025-11-18 13:15:00',NULL,2,0,44.00,NULL,'13987654321','李四',NULL,NULL,NULL,1,1),(5,'9a11c75a-cccb-40a7-9e2a-973cff326fad',2,2,'2025-11-22 18:52:08','2025-11-22 19:04:47',1,1,82.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1),(7,'1b22aa37-bdfc-4a1f-a6ef-93631637d5e1',3,2,'2025-11-22 19:06:39','2025-11-22 19:06:57',1,1,82.00,NULL,NULL,NULL,'用户取消',NULL,'2025-11-22 19:13:03',NULL,1),(8,'c2da8051-3e91-4039-b94f-12b23a83d0a5',1,2,'2025-11-29 15:38:10','2025-11-30 14:59:30',1,1,82.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1),(9,'10e260fc-3551-4c7b-bc95-b6a0f1cd200d',3,2,'2025-11-30 14:56:32','2025-11-30 14:58:28',1,1,82.00,NULL,NULL,NULL,'不想要了',NULL,'2025-11-30 15:02:40',NULL,1),(11,'b629e46e-1a12-4e58-88e9-eda839b5f95b',3,2,'2025-11-30 15:18:03','2025-11-30 15:18:22',1,1,134.00,NULL,NULL,NULL,'不想要了',NULL,'2025-11-30 15:18:59',NULL,1),(12,'03b9b71d-3b74-4134-bcb4-2a65d53d2234',2,1,'2025-12-09 21:38:52','2025-12-11 18:14:02',1,1,58.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1),(13,'ORD000001',1,1,'2025-12-11 18:09:38','2025-12-11 18:09:38',1,1,58.00,'无','13800000001','张三',NULL,NULL,NULL,2,1),(14,'ORD000002',0,2,'2025-12-11 18:09:38',NULL,1,0,22.00,'加辣','13800000002','李四',NULL,NULL,NULL,1,1),(15,'ORD000003',3,3,'2025-12-11 18:09:38','2025-12-11 18:09:38',2,1,46.00,'不要香菜','13800000003','王五',NULL,NULL,NULL,2,1),(16,'ORD000004',4,4,'2025-12-11 18:09:38',NULL,1,0,15.00,'取消','13800000004','赵六','不想要了',NULL,'2025-12-11 18:09:38',0,1),(17,'ORD000005',5,5,'2025-12-11 18:09:38','2025-12-11 18:09:38',2,2,30.00,'退款','13800000005','小红',NULL,NULL,NULL,1,1),(18,'ORD000006',1,6,'2025-12-11 18:09:38','2025-12-11 18:09:38',1,1,33.00,NULL,'13800000006','小明',NULL,NULL,NULL,3,1),(19,'ORD000007',2,7,'2025-12-11 18:09:38','2025-12-11 18:09:38',2,1,48.00,NULL,'13800000007','阿华',NULL,NULL,NULL,1,1),(20,'ORD000008',3,8,'2025-12-11 18:09:38','2025-12-11 18:09:38',1,1,52.00,NULL,'13800000008','小李',NULL,NULL,NULL,2,1),(21,'ORD000009',1,9,'2025-12-11 18:09:38','2025-12-11 18:09:38',2,1,18.00,NULL,'13800000009','小王',NULL,NULL,NULL,1,1),(22,'ORD000010',0,10,'2025-12-11 18:09:38',NULL,1,0,25.00,NULL,'13800000010','陈晨',NULL,NULL,NULL,1,1),(23,'ORD000011',1,11,'2025-12-11 18:09:38','2025-12-11 18:09:38',1,1,35.00,NULL,'13800000011','刘亦',NULL,NULL,NULL,2,1),(24,'ORD000012',4,12,'2025-12-11 18:09:38',NULL,1,0,20.00,NULL,'13800000012','沈阳','临时取消',NULL,'2025-12-11 18:09:38',0,1),(25,'ORD000013',1,13,'2025-12-11 18:09:38','2025-12-11 18:09:38',1,1,40.00,NULL,'13800000013','梁梁',NULL,NULL,NULL,2,1),(26,'ORD000014',2,14,'2025-12-11 18:09:38','2025-12-11 18:09:38',2,1,33.00,NULL,'13800000014','韩梅',NULL,NULL,NULL,1,1),(27,'ORD000015',3,15,'2025-12-11 18:09:38','2025-12-11 18:09:38',1,1,69.00,NULL,'13800000015','冰冰',NULL,NULL,NULL,3,1),(28,'ORD000016',1,16,'2025-12-11 18:09:38','2025-12-11 18:09:38',2,1,22.00,NULL,'13800000016','杰森',NULL,NULL,NULL,1,1),(29,'ORD000017',0,17,'2025-12-11 18:09:38',NULL,1,0,28.00,NULL,'13800000017','安娜',NULL,NULL,NULL,1,1),(30,'ORD000018',5,18,'2025-12-11 18:09:38','2025-12-11 18:09:38',2,2,55.00,NULL,'13800000018','路人甲',NULL,NULL,NULL,2,1),(31,'ORD000019',1,19,'2025-12-11 18:09:38','2025-12-11 18:09:38',1,1,30.00,NULL,'13800000019','路人乙',NULL,NULL,NULL,1,1),(32,'ORD000020',3,20,'2025-12-11 18:09:38','2025-12-11 18:09:38',2,1,46.00,NULL,'13800000020','路人丙',NULL,NULL,NULL,2,1),(33,'ORD000021',1,21,'2025-12-11 18:09:38','2025-12-11 18:09:38',1,1,24.00,NULL,'13800000021','天天',NULL,NULL,NULL,3,1),(34,'ORD000022',2,22,'2025-12-11 18:09:38','2025-12-11 18:09:38',2,1,56.00,NULL,'13800000022','小七',NULL,NULL,NULL,1,1),(35,'ORD000023',4,23,'2025-12-11 18:09:38',NULL,1,0,20.00,NULL,'13800000023','安安','地址错误',NULL,'2025-12-11 18:09:38',0,1),(36,'ORD000024',0,24,'2025-12-11 18:09:38',NULL,1,0,18.00,NULL,'13800000024','格子',NULL,NULL,NULL,1,1),(37,'ORD000025',1,25,'2025-12-11 18:09:38','2025-12-11 18:09:38',2,1,48.00,NULL,'13800000025','小草',NULL,NULL,NULL,2,1),(38,'1d8c0f14-313e-45e2-883e-50bd66bf6e5c',1,1,'2025-12-11 18:28:56',NULL,1,0,85.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1),(39,'38ceeba7-9e24-43cc-a0db-cff8960f2a0c',2,1,'2025-12-11 18:41:15','2025-12-11 18:41:26',1,1,139.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1),(40,'a1924dca-de33-4883-9f50-b686ae4c2132',3,1,'2025-12-11 18:53:00',NULL,1,0,126.00,NULL,NULL,NULL,'用户主动取消',NULL,'2025-12-11 18:55:35',NULL,1),(41,'87e09ae3-55bf-4966-8a0f-fb73010c4241',3,1,'2025-12-11 18:56:28',NULL,1,0,224.00,NULL,NULL,NULL,'用户主动取消',NULL,'2025-12-11 18:56:39',NULL,1),(42,'a7279fb4-2f5f-4015-b8bc-8cc2444b1347',1,1,'2025-12-11 19:01:35',NULL,1,0,776.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1),(43,'62f00f82-84fe-4b41-82c9-fe9ea89d33b2',2,1,'2025-12-11 20:59:34','2025-12-11 20:59:40',1,1,97.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1),(44,'2c196e59-d5f5-4cf0-a3e4-a7112286936b',3,1,'2025-12-11 20:59:53',NULL,1,0,56.00,NULL,NULL,NULL,'用户主动取消',NULL,'2025-12-11 20:59:59',NULL,1),(45,'52e3dfb8-3a4a-4f9b-b4a0-1f2d1036735b',3,1,'2025-12-16 17:38:29',NULL,1,0,64.00,NULL,NULL,NULL,'用户主动取消',NULL,'2025-12-16 17:38:37',NULL,1),(46,'e483e6a2-e8be-43ed-a697-369afcb0d9cb',3,1,'2025-12-16 17:39:59',NULL,1,0,72.00,NULL,NULL,NULL,'用户主动取消',NULL,'2025-12-16 17:40:04',NULL,1),(47,'ec61c8f6-d458-46cc-8ff6-9ec731ded2fa',2,1,'2025-12-17 13:52:50','2025-12-17 13:52:54',1,1,112.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1),(48,'4b2ed573-07c6-45fa-9241-2c9fa619cb0a',1,1,'2025-12-17 15:16:06',NULL,1,0,82.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1),(49,'c98389e3-ef50-4fc7-8b01-0ecb54b87065',1,1,'2025-12-19 10:56:11',NULL,1,0,54.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1),(50,'01d44b4e-e529-44da-b2b1-d8332c356677',3,1,'2025-12-19 14:42:11',NULL,1,0,100.00,NULL,NULL,NULL,'用户主动取消',NULL,'2025-12-19 14:42:19',NULL,1),(51,'fe6c0993-169f-40cf-ae4b-916b3abcf907',2,1,'2025-12-31 09:04:47','2025-12-31 09:08:53',1,1,110.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1),(52,'2b69a02e-7a35-4635-840b-f54cd1aeb7a6',2,1,'2026-01-09 14:07:10','2026-01-09 14:07:14',1,1,80.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1),(53,'65f10d77-7ba7-4df1-8e81-f9ff120b8d18',3,1,'2026-01-12 21:17:51',NULL,1,0,54.00,NULL,NULL,NULL,'用户主动取消',NULL,'2026-01-12 21:17:58',NULL,1),(54,'3e68b45b-5e7c-4f09-9603-4de465016404',3,1,'2026-01-13 10:52:58',NULL,1,0,22.00,NULL,NULL,NULL,'用户主动取消',NULL,'2026-01-13 10:53:04',NULL,1),(55,'92f20abd-81aa-4290-b7e0-b262731def77',3,1,'2026-01-14 14:44:34',NULL,1,0,106.00,NULL,NULL,NULL,'用户主动取消',NULL,'2026-01-14 14:44:39',NULL,1),(56,'90f098a5-50df-4f02-a3db-70cc5ac19c9c',2,1,'2026-01-14 15:25:33','2026-01-14 15:25:45',1,1,44.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1),(57,'242e973a-d052-4cb4-86e4-26cce881b3e2',3,1,'2026-01-15 09:41:50',NULL,1,0,86.00,NULL,NULL,NULL,'用户主动取消',NULL,'2026-01-15 09:41:56',NULL,1),(58,'dc263952-27bd-46f1-b6ec-0610def39fc3',2,1,'2026-01-15 10:13:05','2026-01-15 10:13:15',1,1,131.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1),(59,'1ffbe72c-946e-4a1f-b974-57b9cc488ff0',3,1,'2026-01-15 10:13:44',NULL,1,0,209.00,NULL,NULL,NULL,'用户主动取消',NULL,'2026-01-15 10:13:49',NULL,1);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pay_callback_log`
--

DROP TABLE IF EXISTS `pay_callback_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pay_callback_log` (
                                    `id` bigint NOT NULL AUTO_INCREMENT,
                                    `order_id` bigint NOT NULL,
                                    `provider` varchar(32) NOT NULL,
                                    `callback_no` varchar(128) NOT NULL,
                                    `payload` text,
                                    `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
                                    PRIMARY KEY (`id`),
                                    UNIQUE KEY `uk_provider_callback` (`provider`,`callback_no`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pay_callback_log`
--

LOCK TABLES `pay_callback_log` WRITE;
/*!40000 ALTER TABLE `pay_callback_log` DISABLE KEYS */;
INSERT INTO `pay_callback_log` VALUES (1,1,'WECHAT','cb001','{}','2025-12-11 18:09:38'),(2,2,'ALIPAY','cb002','{}','2025-12-11 18:09:38'),(3,3,'WECHAT','cb003','{}','2025-12-11 18:09:38'),(4,4,'WECHAT','cb004','{}','2025-12-11 18:09:38'),(5,5,'ALIPAY','cb005','{}','2025-12-11 18:09:38'),(6,6,'WECHAT','cb006','{}','2025-12-11 18:09:38'),(7,7,'ALIPAY','cb007','{}','2025-12-11 18:09:38'),(8,8,'WECHAT','cb008','{}','2025-12-11 18:09:38'),(9,9,'ALIPAY','cb009','{}','2025-12-11 18:09:38'),(10,10,'WECHAT','cb010','{}','2025-12-11 18:09:38'),(11,11,'ALIPAY','cb011','{}','2025-12-11 18:09:38'),(12,12,'WECHAT','cb012','{}','2025-12-11 18:09:38'),(13,13,'ALIPAY','cb013','{}','2025-12-11 18:09:38'),(14,14,'WECHAT','cb014','{}','2025-12-11 18:09:38'),(15,15,'ALIPAY','cb015','{}','2025-12-11 18:09:38'),(16,16,'WECHAT','cb016','{}','2025-12-11 18:09:38'),(17,17,'ALIPAY','cb017','{}','2025-12-11 18:09:38'),(18,18,'WECHAT','cb018','{}','2025-12-11 18:09:38'),(19,19,'ALIPAY','cb019','{}','2025-12-11 18:09:38'),(20,20,'WECHAT','cb020','{}','2025-12-11 18:09:38'),(21,21,'ALIPAY','cb021','{}','2025-12-11 18:09:38'),(22,22,'WECHAT','cb022','{}','2025-12-11 18:09:38'),(23,23,'ALIPAY','cb023','{}','2025-12-11 18:09:38'),(24,24,'WECHAT','cb024','{}','2025-12-11 18:09:38'),(25,25,'ALIPAY','cb025','{}','2025-12-11 18:09:38');
/*!40000 ALTER TABLE `pay_callback_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
                        `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                        `openid` varchar(45) DEFAULT NULL COMMENT '微信 OpenID',
                        `name` varchar(32) DEFAULT NULL COMMENT '姓名',
                        `phone` varchar(11) DEFAULT NULL COMMENT '手机号',
                        `sex` varchar(2) DEFAULT NULL COMMENT '性别',
                        `id_number` varchar(18) DEFAULT NULL COMMENT '身份证号',
                        `avatar` varchar(500) DEFAULT NULL COMMENT '头像地址',
                        `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                        PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'oWx123456789abcdef01','张三','13812345678','男','110101199001011234','https://example.com/avatar/zhangsan.jpg','2025-11-18 16:18:22'),(2,'oWy987654321fedcba02','李四','13987654321','女','110101199202022345','https://example.com/avatar/lisi.jpg','2025-11-18 16:18:22'),(3,'wx001','张三','13800000001','男','110101199001010011','/img/u1.jpg','2025-12-11 18:09:38'),(4,'wx002','李四','13800000002','男','110101199002020022','/img/u2.jpg','2025-12-11 18:09:38'),(5,'wx003','王五','13800000003','女','110101199003030033','/img/u3.jpg','2025-12-11 18:09:38'),(6,'wx004','赵六','13800000004','男','110101199004040044','/img/u4.jpg','2025-12-11 18:09:38'),(7,'wx005','小红','13800000005','女','110101199005050055','/img/u5.jpg','2025-12-11 18:09:38'),(8,'wx006','小明','13800000006','男','110101199006060066','/img/u6.jpg','2025-12-11 18:09:38'),(9,'wx007','阿华','13800000007','女','110101199007070077','/img/u7.jpg','2025-12-11 18:09:38'),(10,'wx008','小李','13800000008','男','110101199008080088','/img/u8.jpg','2025-12-11 18:09:38'),(11,'wx009','小王','13800000009','女','110101199009090099','/img/u9.jpg','2025-12-11 18:09:38'),(12,'wx010','陈晨','13800000010','男','110101199010100010','/img/u10.jpg','2025-12-11 18:09:38'),(13,'wx011','刘亦','13800000011','女','110101199011110011','/img/u11.jpg','2025-12-11 18:09:38'),(14,'wx012','沈阳','13800000012','男','110101199012120012','/img/u12.jpg','2025-12-11 18:09:38'),(15,'wx013','梁梁','13800000013','男','110101199101010013','/img/u13.jpg','2025-12-11 18:09:38'),(16,'wx014','韩梅','13800000014','女','110101199102020014','/img/u14.jpg','2025-12-11 18:09:38'),(17,'wx015','冰冰','13800000015','女','110101199103030015','/img/u15.jpg','2025-12-11 18:09:38'),(18,'wx016','杰森','13800000016','男','110101199104040016','/img/u16.jpg','2025-12-11 18:09:38'),(19,'wx017','安娜','13800000017','女','110101199105050017','/img/u17.jpg','2025-12-11 18:09:38'),(20,'wx018','路人甲','13800000018','男','110101199106060018','/img/u18.jpg','2025-12-11 18:09:38'),(21,'wx019','路人乙','13800000019','女','110101199107070019','/img/u19.jpg','2025-12-11 18:09:38'),(22,'wx020','路人丙','13800000020','男','110101199108080020','/img/u20.jpg','2025-12-11 18:09:38'),(23,'wx021','天天','13800000021','女','110101199109090021','/img/u21.jpg','2025-12-11 18:09:38'),(24,'wx022','小七','13800000022','男','110101199110100022','/img/u22.jpg','2025-12-11 18:09:38'),(25,'wx023','安安','13800000023','女','110101199111110023','/img/u23.jpg','2025-12-11 18:09:38'),(26,'wx024','格子','13800000024','男','110101199112120024','/img/u24.jpg','2025-12-11 18:09:38'),(27,'wx025','小草','13800000025','女','110101199201010025','/img/u25.jpg','2025-12-11 18:09:38');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-16 15:01:07
