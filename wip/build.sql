/*
SQLyog Community v12.2.1 (64 bit)
MySQL - 5.5.44-MariaDB-wsrep : Database - utest
*********************************************************************
*/

/*** Caution: If you have previously installed version of UTest please    ***/
/***          make sure you bacck up your SQL tables [results] and [test] ***/
/***          in order to not lose data with this installation            ***/

DROP DATABASE utest;
CREATE DATABASE utest DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`utest` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `utest`;

/*Table structure for table `results` */

DROP TABLE IF EXISTS `results`;

CREATE TABLE `results` (
  `aid` int(20) NOT NULL AUTO_INCREMENT,
  `test_id` int(20) NOT NULL DEFAULT '0',
  `batch_id` varchar(32) NOT NULL DEFAULT '',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Changed on insert/update',
  `exec_time` varchar(20) NOT NULL DEFAULT 'N/A',
  `testcase` varchar(100) NOT NULL DEFAULT 'N/A',
  `pos` int(20) NOT NULL DEFAULT '0' COMMENT 'Should reflect order in which the assertions are run',
  `flag` enum('FAIL','PASS') NOT NULL DEFAULT 'FAIL',
  `assertion` text NOT NULL COMMENT 'Comment N/A',
  PRIMARY KEY (`aid`),
  UNIQUE KEY `test_id` (`test_id`,`pos`,`batch_id`),
  KEY `fk_test_id` (`test_id`),
  CONSTRAINT `fk_test_id_exists` FOREIGN KEY (`test_id`) REFERENCES `test` (`tid`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;

/*Table structure for table `test` */

DROP TABLE IF EXISTS `test`;

CREATE TABLE `test` (
  `tid` int(20) NOT NULL AUTO_INCREMENT,
  `test` varchar(250) NOT NULL DEFAULT '',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Changed on insert/update',
  PRIMARY KEY (`tid`),
  UNIQUE KEY `test` (`test`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

/* Function  structure for function  `assertEqual` */

/*!50003 DROP FUNCTION IF EXISTS `assertEqual` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `assertEqual`(
    sFirst VARCHAR(3000), 
    sSecond VARCHAR(3000), 
    sMessage VARCHAR(250)
) RETURNS varchar(10) CHARSET utf8
    READS SQL DATA
BEGIN
    DECLARE sResult     VARCHAR(10);
    DECLARE sFlag       VARCHAR(10);
    DECLARE sMsgToStore VARCHAR(250);
    DECLARE iRecId      INT(20);
    SET sResult     = equal(sFirst, sSecond);
    SET sMsgToStore = IF((sMessage IS NULL), 'N/A', sMessage);
    SET sFlag       = IF((sResult=flagTRUE()), 'PASS', 'FAIL');
    
    SET iRecId = registerAssertion(
        sFlag,
        sMsgToStore,
        'assertEqual',
        'N/A',
        getTestNameId(),
        getUniqueId(),
        getIncrementedTestPosition()
    );
    
    RETURN sFlag;
END */$$
DELIMITER ;

/* Function  structure for function  `assertNotEqual` */

/*!50003 DROP FUNCTION IF EXISTS `assertNotEqual` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `assertNotEqual`(
    sFirst VARCHAR(3000), 
    sSecond VARCHAR(3000), 
    sMessage VARCHAR(250)
) RETURNS varchar(10) CHARSET utf8
    READS SQL DATA
BEGIN
    DECLARE sResult     VARCHAR(10);
    DECLARE sFlag       VARCHAR(10);
    DECLARE sMsgToStore VARCHAR(10);
    DECLARE iRecId      INT(20);
    SET sResult     = equal(sFirst, sSecond);
    SET sMsgToStore = IF((sMessage IS NULL), 'N/A', sMessage);
    SET sFlag       = IF((sResult=flagTRUE()), 'FAIL', 'PASS');
    
    SET iRecId = registerAssertion(
        sFlag,
        sMsgToStore,
        'assertNoEqual',
        'N/A',
        getTestNameId(),
        getUniqueId(),
        getIncrementedTestPosition()
    );
    
    RETURN sFlag;
END */$$
DELIMITER ;

/* Function  structure for function  `equal` */

/*!50003 DROP FUNCTION IF EXISTS `equal` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `equal`(
  sStrOne VARCHAR(3000),
  sStrTwo VARCHAR(3000)
) RETURNS varchar(250) CHARSET utf8
    READS SQL DATA
BEGIN
    DECLARE sTrue  VARCHAR(10);
    DECLARE sFalse VARCHAR(10);
    SET sTrue  = flagTRUE();
    SET sFalse = flagFALSE();
    
    IF (sStrOne IS NULL OR sStrTwo IS NULL) THEN
        IF (sStrOne IS NULL AND sStrTwo IS NULL) THEN
            RETURN flagTRUE();
        ELSE
            RETURN flagFALSE();
        END IF;
    ELSE
        IF (MD5(sStrOne)=MD5(sStrTwo)) THEN
            RETURN flagTRUE();
        ELSE
            RETURN flagFALSE();
        END IF;
    END IF;
   
END */$$
DELIMITER ;

/* Function  structure for function  `flagFALSE` */

/*!50003 DROP FUNCTION IF EXISTS `flagFALSE` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `flagFALSE`() RETURNS varchar(10) CHARSET utf8
    READS SQL DATA
BEGIN
    RETURN 'FALSE';
END */$$
DELIMITER ;

/* Function  structure for function  `flagTRUE` */

/*!50003 DROP FUNCTION IF EXISTS `flagTRUE` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `flagTRUE`() RETURNS varchar(10) CHARSET utf8
    READS SQL DATA
BEGIN
    RETURN 'TRUE';
END */$$
DELIMITER ;

/* Function  structure for function  `generateUniqueId` */

/*!50003 DROP FUNCTION IF EXISTS `generateUniqueId` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `generateUniqueId`(
) RETURNS varchar(32) CHARSET utf8
    READS SQL DATA
BEGIN
   RETURN UCASE(MD5(CONCAT(UUID(), '--', RAND())));
END */$$
DELIMITER ;

/* Function  structure for function  `getIncrementedTestPosition` */

/*!50003 DROP FUNCTION IF EXISTS `getIncrementedTestPosition` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `getIncrementedTestPosition`(
) RETURNS int(20)
    READS SQL DATA
BEGIN
   CALL incrementPosition();
   RETURN getTestPosition();
END */$$
DELIMITER ;

/* Function  structure for function  `getTestIdByName` */

/*!50003 DROP FUNCTION IF EXISTS `getTestIdByName` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `getTestIdByName`(
  sTestName VARCHAR(250)
) RETURNS int(20)
    READS SQL DATA
BEGIN
    DECLARE iRecId INT(20);
    SET iRecId = (SELECT tid FROM test WHERE test = @utestTestName);
    RETURN IF(iRecId IS NULL, 0, iRecId);
END */$$
DELIMITER ;

/* Function  structure for function  `getTestName` */

/*!50003 DROP FUNCTION IF EXISTS `getTestName` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `getTestName`(
) RETURNS varchar(255) CHARSET utf8
    READS SQL DATA
BEGIN
   RETURN IF(@utestTestName IS NULL, 'NULL', @utestTestName);
END */$$
DELIMITER ;

/* Function  structure for function  `getTestNameId` */

/*!50003 DROP FUNCTION IF EXISTS `getTestNameId` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `getTestNameId`(
) RETURNS int(20)
    READS SQL DATA
BEGIN
   RETURN IF(@utestTestNameId IS NULL, 'NULL', @utestTestNameId);
END */$$
DELIMITER ;

/* Function  structure for function  `getTestPosition` */

/*!50003 DROP FUNCTION IF EXISTS `getTestPosition` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `getTestPosition`(
) RETURNS int(20)
    READS SQL DATA
BEGIN
   RETURN IF(@utestTestPosition IS NULL, 'NULL', @utestTestPosition);
END */$$
DELIMITER ;

/* Function  structure for function  `getUniqueId` */

/*!50003 DROP FUNCTION IF EXISTS `getUniqueId` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `getUniqueId`(
) RETURNS varchar(32) CHARSET utf8
    READS SQL DATA
BEGIN
   RETURN IF(@utestTestId IS NULL, 'NULL', @utestTestId);
END */$$
DELIMITER ;

/* Function  structure for function  `jsonReporter` */

/*!50003 DROP FUNCTION IF EXISTS `jsonReporter` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `jsonReporter`(
    batch_md5 VARCHAR(32)
) RETURNS varchar(8000) CHARSET utf8
    READS SQL DATA
BEGIN
    /*** declarations ***/
    DECLARE sJsonOut VARCHAR(8000);
    DECLARE sJsonTemplate VARCHAR(8000);
    DECLARE sJsonHeader VARCHAR(4000);
    DECLARE sJsonAsserts VARCHAR(4000);
    
    /*** parts ***/
    SET sJsonHeader = jsonTestHeader(batch_md5);
    SET sJsonAsserts = jsonAssertDataCollate(batch_md5);
    SET sJsonOut = CONCAT("{", sJsonHeader, ',"details":{', sJsonAsserts, '}}');
	RETURN TRIM(sJsonOut);
END */$$
DELIMITER ;

/* Function  structure for function  `nvl` */

/*!50003 DROP FUNCTION IF EXISTS `nvl` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `nvl`(
  sInput VARCHAR(250),
  sReplaceWith VARCHAR(250)
) RETURNS varchar(250) CHARSET utf8
    READS SQL DATA
BEGIN
    DECLARE sReplace VARCHAR(250);
    SET sReplace = IF((sReplaceWith IS NULL), '', sReplaceWith);
    RETURN IF((sInput IS NULL), sReplace, sInput);
   
END */$$
DELIMITER ;

/* Function  structure for function  `jsonAssertDataCollate` */

/*!50003 DROP FUNCTION IF EXISTS `jsonAssertDataCollate` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `jsonAssertDataCollate`(
    batch_md5 VARCHAR(32)
) RETURNS varchar(4000) CHARSET utf8
    READS SQL DATA
BEGIN
    /*** Basic vars ***/
    DECLARE sJsonOut VARCHAR(4000);
    DECLARE sJsonTmp VARCHAR(4000);
    DECLARE done INT DEFAULT 0;
    /*** Ones to use with cursor line fetch ***/
    DECLARE aid INT(20);
    DECLARE test_id	INT(20);
    DECLARE batch_id VARCHAR(32);			
    DECLARE modified VARCHAR(20);
    DECLARE exec_time VARCHAR(20);
    DECLARE testcase VARCHAR(100);
    DECLARE pos INT(20);
    DECLARE flag VARCHAR(5);
    DECLARE assert VARCHAR(1000);
    
    /*** Cursor ***/
    DECLARE cResults CURSOR 
    FOR 
    SELECT r.* 
      FROM results r 
     WHERE r.batch_id = batch_md5 
     ORDER BY r.pos ASC;
    /*** Handlers are defined always after the cursor ***/
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    DECLARE CONTINUE HANDLER FOR Sqlstate '02000' SET done = 1;
    /*** Open the cursor ***/
    OPEN cResults;
    /*** reset pointers and lines ***/
    SET sJsonOut = "";
    SET sJsonTmp = "";
    read_results: LOOP
        IF done = 1 THEN
            LEAVE read_results;
        END IF;
        FETCH cResults INTO aid, test_id, batch_id, modified, exec_time, testcase, pos, flag, assert;
        SET sJsonTmp = (SELECT jsonDataRow(aid, test_id, batch_id, modified, exec_time, testcase, pos, flag, assert));
        SET sJsonOut = (SELECT IF(LENGTH(sJsonOut)=0, sJsonTmp, CONCAT(sJsonOut, ",", sJsonTmp)));
    END LOOP;
    RETURN sJsonOut;
END */$$
DELIMITER ;

/* Function  structure for function  `jsonDataRow` */

/*!50003 DROP FUNCTION IF EXISTS `jsonDataRow` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `jsonDataRow`(
    aid INT(20),
    test_id	INT(20),
    batch_id VARCHAR(32),			
    modified VARCHAR(20),
    exec_time VARCHAR(20),
    testcase VARCHAR(100),
    pos INT(20),
    flag VARCHAR(5),
    assert VARCHAR(1000)
) RETURNS varchar(2000) CHARSET utf8
    READS SQL DATA
BEGIN
    DECLARE sJsonOut VARCHAR(3000);
    SET sJsonOut = '"%aid%":{"aid":"%aid%","test_id":"%test_id%","batch_id":"%batch_id%","modified":"%modified%","exec_time":"%exec_time%","testcase":"%testcase%","pos":"%pos%","flag":"%flag%","assertion":"%assertion%"}';
    
    SET sJsonOut = REPLACE(sJsonOut, "%aid%", nvl(aid, 0));
    SET sJsonOut = REPLACE(sJsonOut, "%test_id%", nvl(test_id, 0));
    SET sJsonOut = REPLACE(sJsonOut, "%batch_id%", nvl(batch_id, ''));
    SET sJsonOut = REPLACE(sJsonOut, "%modified%", nvl(modified, ''));
    SET sJsonOut = REPLACE(sJsonOut, "%exec_time%", nvl(exec_time, ''));
    SET sJsonOut = REPLACE(sJsonOut, "%testcase%", nvl(testcase, ''));
    SET sJsonOut = REPLACE(sJsonOut, "%pos%", nvl(pos, 0));
    SET sJsonOut = REPLACE(sJsonOut, "%flag%", nvl(flag, 'ERR'));
    SET sJsonOut = REPLACE(sJsonOut, "%assertion%", nvl(assert, ''));
    RETURN sJsonOut;
END */$$
DELIMITER ;

/* Function  structure for function  `jsonTestHeader` */

/*!50003 DROP FUNCTION IF EXISTS `jsonTestHeader` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `jsonTestHeader`(
    batch_md5 VARCHAR(32)
) RETURNS varchar(4000) CHARSET utf8
    READS SQL DATA
BEGIN
    /*** Basic vars ***/
    DECLARE sJsonOut VARCHAR(4000);
    DECLARE sJsonTemplate VARCHAR(4000);
    DECLARE test_id INT(20);
    DECLARE test_name VARCHAR(250);
    DECLARE test_created VARCHAR(19);
    DECLARE assert_batch_id VARCHAR(32);
    DECLARE assert_started VARCHAR(19);
    DECLARE assertions_total INT(20);
    DECLARE assertions_fail INT(20);
    DECLARE assertions_pass INT(20);
    /*** populate all vars ***/
    SELECT t.tid AS test_id
         , t.test AS test_name
         , t.modified AS test_created
         , r.batch_id AS assert_batch_id
         , r.modified AS assert_started
         , (SELECT COUNT(*) FROM results rs WHERE rs.batch_id = batch_md5) AS assertions_total 
         , (SELECT COUNT(*) FROM results rs WHERE rs.batch_id = batch_md5 AND rs.flag = 'FAIL') AS assertions_fail 
         , (SELECT COUNT(*) FROM results rs WHERE rs.batch_id = batch_md5 AND rs.flag = 'PASS') AS assertions_pass 
      INTO test_id
         , test_name
         , test_created
         , assert_batch_id
         , assert_started
         , assertions_total
         , assertions_fail
         , assertions_pass
      FROM results r JOIN test t ON t.tid = r.test_id
     WHERE r.batch_id = batch_md5
     ORDER BY r.aid ASC
     LIMIT 1;
     /*** JSON template ***/
    SET sJsonTemplate = '"test_name": "%TEST_NAME%","test_id": "%TEST_ID%","test_created": "%TEST_CREATED%","assertions_total": "%ASSRT_TOTAL%","assertions_pass": "%ASSRT_PASS%","assertions_fail": "%ASSRT_FAIL%","assertions_batch_id": "%ASSRT_BATCH_ID%","assertions_batch_run": "%ASSRT_BATCH_RUN%"';
    SET sJsonOut = REPLACE(sJsonTemplate, '%TEST_NAME%', nvl(test_name, ''));
    SET sJsonOut = REPLACE(sJsonOut, '%TEST_ID%', nvl(test_id, ''));
    SET sJsonOut = REPLACE(sJsonOut, '%TEST_CREATED%', nvl(test_created, ''));
    SET sJsonOut = REPLACE(sJsonOut, '%ASSRT_TOTAL%', nvl(assertions_total, 'ERR'));
    SET sJsonOut = REPLACE(sJsonOut, '%ASSRT_PASS%', nvl(assertions_pass, 'ERR'));
    SET sJsonOut = REPLACE(sJsonOut, '%ASSRT_FAIL%', nvl(assertions_fail, 'ERR'));
    SET sJsonOut = REPLACE(sJsonOut, '%ASSRT_BATCH_ID%', nvl(assert_batch_id, ''));
    SET sJsonOut = REPLACE(sJsonOut, '%ASSRT_BATCH_RUN%', nvl(assert_started, ''));
    RETURN sJsonOut;
END */$$
DELIMITER ;

/* Function  structure for function  `saveTestName` */

/*!50003 DROP FUNCTION IF EXISTS `saveTestName` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `saveTestName`(
  sTestName VARCHAR(250)
) RETURNS int(20)
    READS SQL DATA
BEGIN
    DECLARE iRecId INT(20);
    SET @utestTestName = sTestName;
    SET iRecId = getTestIdByName(@utestTestName);
    IF (iRecId=0) THEN
        INSERT INTO test (test) VALUES (@utestTestName);
    END IF;
    RETURN getTestIdByName(@utestTestName);
   
END */$$
DELIMITER ;

/* Function  structure for function  `setTestName` */

/*!50003 DROP FUNCTION IF EXISTS `setTestName` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `setTestName`(
  sTestName VARCHAR(250)
) RETURNS varchar(255) CHARSET utf8
    READS SQL DATA
BEGIN
   SET @utestTestName = sTestName;
   RETURN IF(@utestTestName IS NULL, 'NULL', @utestTestName);
END */$$
DELIMITER ;

/* Function  structure for function  `setTestNameId` */

/*!50003 DROP FUNCTION IF EXISTS `setTestNameId` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `setTestNameId`(
  iTestId INT(20)
) RETURNS varchar(255) CHARSET utf8
    READS SQL DATA
BEGIN
   SET @utestTestNameId = iTestId;
   RETURN IF(@utestTestNameId IS NULL, 'NULL', @utestTestNameId);
END */$$
DELIMITER ;

/* Function  structure for function  `registerAssertion` */

/*!50003 DROP FUNCTION IF EXISTS `registerAssertion` */;
DELIMITER $$

/*!50003 CREATE FUNCTION `registerAssertion`(
    sStatus VARCHAR(10),
    sComment VARCHAR(250),
    sTestCase VARCHAR(250),
    sExecTime VARCHAR(20),
    iTestNameId INT(20),
    sTestMd5 VARCHAR(32),
    iPosition INT(20)
) RETURNS int(20)
    READS SQL DATA
BEGIN
    DECLARE iRecId INT(20);
    INSERT INTO results (
      test_id
      , batch_id
      , pos
      , flag
      , testcase
      , assertion
      , exec_time
    ) VALUES (
      nvl(iTestNameId, 0)
      , nvl(sTestMd5, '')
      , nvl(iPosition, 0)
      , IF((sStatus!='FAIL' AND sStatus!='PASS'), 'FAIL', sStatus)
      , nvl(sTestCase, 'N/A')
      , TRIM(nvl(sComment, ''))
      , nvl(sExecTime, '0')
    );
    SET iRecId = (
        SELECT aid 
          FROM results
         WHERE test_id = nvl(iTestNameId, 0)
           AND pos     = nvl(iPosition, 0)
           AND batch_id = nvl(sTestMd5, '')
    );
    RETURN IF((iRecId IS NULL), 0, iRecId);
END */$$
DELIMITER ;

/* Procedure structure for procedure `assignValue` */

/*!50003 DROP PROCEDURE IF EXISTS  `assignValue` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `assignValue`(OUT var VARCHAR(255), val VARCHAR(255))
BEGIN
    SELECT val INTO var;
  END */$$
DELIMITER ;

/* Procedure structure for procedure `incrementPosition` */

/*!50003 DROP PROCEDURE IF EXISTS  `incrementPosition` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `incrementPosition`()
BEGIN
    CALL assignValue(@utestTestPosition, (@utestTestPosition+1));
  END */$$
DELIMITER ;

/* Procedure structure for procedure `initTest` */

/*!50003 DROP PROCEDURE IF EXISTS  `initTest` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `initTest`()
BEGIN
    SET @utestTestName     = '';
    SET @utestTestNameId   = 0;
    SET @utestTestId       = generateUniqueId();
    SET @utestTestPosition = 0;
  END */$$
DELIMITER ;

/* Procedure structure for procedure `reportTestResults` */

/*!50003 DROP PROCEDURE IF EXISTS  `reportTestResults` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `reportTestResults`()
BEGIN
    SELECT (SELECT CONCAT('Test name: ', test_name) FROM results_summary WHERE batch_id = getUniqueId() LIMIT 1) AS details
    UNION
    SELECT (SELECT CONCAT('Start: ', run) FROM results_summary WHERE batch_id = getUniqueId() ORDER BY pos ASC LIMIT 1) AS details
    UNION
    SELECT (SELECT CONCAT('End:   ', run) FROM results_summary WHERE batch_id = getUniqueId() ORDER BY pos DESC LIMIT 1) AS details
    UNION
    SELECT ' ' AS details
    UNION
    SELECT descr_compact AS details
    FROM results_summary WHERE batch_id = getUniqueId();
  END */$$
DELIMITER ;

/* Procedure structure for procedure `utAssertEqual` */

/*!50003 DROP PROCEDURE IF EXISTS  `utAssertEqual` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `utAssertEqual`(
    sFirst VARCHAR(3000), 
    sSecond VARCHAR(3000), 
    sMessage VARCHAR(250)    
)
BEGIN
    DECLARE sTemp VARCHAR(3000);
    SET sTemp = (SELECT utest.assertEqual(sFirst, sSecond, sMessage));
  END */$$
DELIMITER ;

/* Procedure structure for procedure `utAssertNotEqual` */

/*!50003 DROP PROCEDURE IF EXISTS  `utAssertNotEqual` */;

DELIMITER $$

/*!50003 CREATE PROCEDURE `utAssertNotEqual`(
    sFirst VARCHAR(3000), 
    sSecond VARCHAR(3000), 
    sMessage VARCHAR(250)    
)
BEGIN
    DECLARE sTemp VARCHAR(3000);
    SET sTemp = (SELECT utest.assertNotEqual(sFirst, sSecond, sMessage));
  END */$$
DELIMITER ;

/*Table structure for table `results_summary` */

DROP TABLE IF EXISTS `results_summary`;

/*!50001 DROP VIEW IF EXISTS `results_summary` */;
/*!50001 DROP TABLE IF EXISTS `results_summary` */;

/*!50001 CREATE TABLE  `results_summary`(
 `test_name` varchar(250) ,
 `aid` int(20) ,
 `batch_id` varchar(32) ,
 `test_id` int(20) ,
 `run` timestamp ,
 `pos` int(20) ,
 `flag` enum('FAIL','PASS') ,
 `descr` text ,
 `descr_compact` mediumtext 
)*/;

/*View structure for view results_summary */

/*!50001 DROP TABLE IF EXISTS `results_summary` */;
/*!50001 DROP VIEW IF EXISTS `results_summary` */;

/*!50001 CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `results_summary` AS select `t`.`test` AS `test_name`,`r`.`aid` AS `aid`,`r`.`batch_id` AS `batch_id`,`r`.`test_id` AS `test_id`,`r`.`modified` AS `run`,`r`.`pos` AS `pos`,`r`.`flag` AS `flag`,`r`.`assertion` AS `descr`,concat_ws(' ',concat(`r`.`pos`,'.'),`r`.`flag`,'-',`r`.`assertion`) AS `descr_compact` from (`results` `r` join `test` `t` on((`t`.`tid` = `r`.`test_id`))) */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
