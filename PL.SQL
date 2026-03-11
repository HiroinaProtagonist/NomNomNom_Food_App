-- Citation for the following code:
-- Date: 3/1/2026
-- Adapted from PL/SQL assignment starter code and Step 4 Draft starter code
-- (https://canvas.oregonstate.edu/courses/2031764/assignments/10323329?module_item_id=26243433,
-- https://canvas.oregonstate.edu/courses/2031764/assignments/10323339?module_item_id=26243440)
-- Changes made beyond the starter code are our own without reference to AI

-- Citation for Flower Meanings: http://www.allflorists.co.uk/advice_flowerMeanings.asp

-- CALL DDL STATEMENTS TO RESET TABLES AND DATA
-- DDL Group 126
DROP PROCEDURE IF EXISTS sp_ddl;
DELIMITER //
CREATE PROCEDURE sp_ddl()
BEGIN
    DECLARE descript1 VARCHAR(255);
    SET FOREIGN_KEY_CHECKS=0;
    SET AUTOCOMMIT = 0;

    DROP TABLE IF EXISTS COLORS;
    DROP TABLE IF EXISTS FLOWERS_BOUQUETS;
    DROP TABLE IF EXISTS BOUQUETS;
    DROP TABLE IF EXISTS FLOWERS;
    DROP TABLE IF EXISTS MAKERS;
    DROP TABLE IF EXISTS RECIPIENTS;

    CREATE TABLE MAKERS (
        MAKER_ID INT(11) AUTO_INCREMENT NOT NULL,
        FNAME VARCHAR(255) NOT NULL,
        LNAME VARCHAR(255) NOT NULL,
        PHONE VARCHAR(10),
        HANDLE VARCHAR(255) NOT NULL,
        EMAIL VARCHAR(255),
        PRIMARY KEY (MAKER_ID)
    );

    CREATE TABLE RECIPIENTS (
        RECIPIENT_ID INT(11) AUTO_INCREMENT NOT NULL,
        FNAME VARCHAR(255) NOT NULL,
        LNAME VARCHAR(255) NOT NULL,
        PHONE VARCHAR(10),
        HANDLE VARCHAR(20) NOT NULL,
        EMAIL VARCHAR(255),
        PRIMARY KEY (RECIPIENT_ID)
    );

    CREATE TABLE FLOWERS (
         FLOWER_ID INT(11) AUTO_INCREMENT NOT NULL,
         NAME VARCHAR(50) NOT NULL,
         COLOR_ID INT(11) NOT NULL,
         MEANING VARCHAR(50) NOT NULL,
         FOREIGN KEY (COLOR_ID) REFERENCES COLORS(COLOR_ID),
         PRIMARY KEY (FLOWER_ID)
    );

    CREATE TABLE COLORS (
        COLOR_ID INT(11) AUTO_INCREMENT NOT NULL,
        COLOR VARCHAR(50) NOT NULL,
        PRIMARY KEY (COLOR_ID)
    );

    CREATE TABLE BOUQUETS (
        BOUQUET_ID INT(11) AUTO_INCREMENT NOT NULL,
        NAME VARCHAR(50) NOT NULL,
        DESCRIPTION VARCHAR(255),
        MAKER_ID INT(11) NOT NULL,
        RECIPIENT_ID INT(11),
        FOREIGN KEY (MAKER_ID) REFERENCES MAKERS(MAKER_ID) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (RECIPIENT_ID) REFERENCES RECIPIENTS(RECIPIENT_ID) ON DELETE CASCADE ON UPDATE CASCADE,
        PRIMARY KEY (BOUQUET_ID)
    );

    CREATE TABLE FLOWERS_BOUQUETS (
        FLOWER_ID INT(11) NOT NULL,
        BOUQUET_ID INT(11) NOT NULL,
        FOREIGN KEY (FLOWER_ID) REFERENCES FLOWERS(FLOWER_ID) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (BOUQUET_ID) REFERENCES BOUQUETS(BOUQUET_ID) ON DELETE CASCADE ON UPDATE CASCADE,
        PRIMARY KEY (FLOWER_ID, BOUQUET_ID)
    );

    INSERT INTO COLORS (COLOR)
    VALUES
        ('Any'),
        ('Solid'),
        ('Striped'),
        ('Red'),
        ('Pink'),
        ('Blue'),
        ('White'),
        ('Yellow'),
        ('Orange'),
        ('Black'),
        ('Maroon'),
        ('Green');

    INSERT INTO MAKERS (FNAME, LNAME, PHONE, HANDLE, EMAIL)
    VALUES
        ('David', 'Hawthorne', '9175320981',
         'Thorne', 'hawthorne@gmail.com'),
        ('Yara', 'Coulibaly', '5319857942',
         'CoolYara', 'coulibaly_yara@mail.com'),
        ('Anderson', 'Wren', '888548319', 'TheOneTrueKing', NULL);

    INSERT INTO RECIPIENTS (FNAME, LNAME, PHONE, HANDLE, EMAIL)
    VALUES
        ('Anya', 'Noches', '5079814543',
         'Yaaaya', 'noches_a@gmail.com'),
        ('William', 'Bennett', '1234567890',
         'WILLL444', 'bennettw@mail.com'),
        ('Lilith', 'Jones', NULL, 'ITSLIL', 'thislilith7@aol.com');

    INSERT INTO FLOWERS (NAME, MEANING, COLOR_ID)
    VALUES
        ('Carnation','Fascination', (SELECT COLOR_ID FROM COLORS WHERE COLOR = 'Any')),
        ('Carnation','Admiration', (SELECT COLOR_ID FROM COLORS WHERE COLOR = 'Red')),
        ('Mint','Virtue', (SELECT COLOR_ID FROM COLORS WHERE COLOR = 'Green')),
        ('Sweet Pea','Departure', (SELECT COLOR_ID FROM COLORS WHERE COLOR = 'Any')),
        ('Wall Flower', 'Fidelity in Adversity', (SELECT COLOR_ID FROM COLORS WHERE COLOR = 'Any'));

    INSERT INTO BOUQUETS (NAME, DESCRIPTION, MAKER_ID, RECIPIENT_ID)
    VALUES
        ('FirstBouquet', NULL, (SELECT MAKER_ID FROM MAKERS WHERE HANDLE='TheOneTrueKing'), NULL),
        ('AnyColor', NULL, (SELECT MAKER_ID FROM MAKERS WHERE HANDLE='CoolYara'), NULL),
        ('AllCarnations', NULL, (SELECT MAKER_ID FROM MAKERS WHERE HANDLE='TheOneTrueKing'), NULL);

    INSERT INTO FLOWERS_BOUQUETS (FLOWER_ID, BOUQUET_ID)
    VALUES
        ((SELECT FLOWER_ID FROM FLOWERS AS F
            LEFT JOIN COLORS AS C ON C.COLOR_ID = F.COLOR_ID
            WHERE F.NAME = 'Carnation' AND C.COLOR = 'Red'),

         (SELECT BOUQUET_ID FROM BOUQUETS
            WHERE NAME = 'FirstBouquet'
            AND MAKER_ID = (SELECT MAKER_ID FROM MAKERS WHERE HANDLE='TheOneTrueKing')));

    INSERT INTO FLOWERS_BOUQUETS (FLOWER_ID, BOUQUET_ID)
    VALUES
        ((SELECT FLOWER_ID FROM FLOWERS AS F
            LEFT JOIN COLORS AS C ON C.COLOR_ID = F.COLOR_ID
            WHERE F.NAME = 'Carnation' AND C.COLOR = 'Red'),

         (SELECT BOUQUET_ID FROM BOUQUETS
            WHERE NAME = 'AllCarnations'
            AND MAKER_ID = (SELECT MAKER_ID FROM MAKERS WHERE HANDLE='TheOneTrueKing')));

    INSERT INTO FLOWERS_BOUQUETS (FLOWER_ID, BOUQUET_ID)
    VALUES
        ((SELECT FLOWER_ID FROM FLOWERS AS F
            LEFT JOIN COLORS AS C ON C.COLOR_ID = F.COLOR_ID
            WHERE F.NAME = 'Carnation' AND C.COLOR = 'Any'),

     (SELECT BOUQUET_ID FROM BOUQUETS
            WHERE NAME = 'AllCarnations'
            AND MAKER_ID = (SELECT MAKER_ID FROM MAKERS WHERE HANDLE='TheOneTrueKing')));

    INSERT INTO FLOWERS_BOUQUETS (FLOWER_ID, BOUQUET_ID)
    VALUES
        ((SELECT FLOWER_ID FROM FLOWERS AS F
            LEFT JOIN COLORS AS C ON C.COLOR_ID = F.COLOR_ID
            WHERE F.NAME = 'Sweet Pea' AND C.COLOR = 'Any'),

         (SELECT BOUQUET_ID FROM BOUQUETS
            WHERE NAME = 'AnyColor'
            AND MAKER_ID = (SELECT MAKER_ID FROM MAKERS WHERE HANDLE='CoolYara')));

    SET FOREIGN_KEY_CHECKS=1;
    COMMIT;
END //
DELIMITER ;

-- FLOWERS CUD operations
-- To create/insert into the FLOWERS table
DROP PROCEDURE IF EXISTS sp_create_flower;
DELIMITER //
CREATE PROCEDURE sp_create_flower(
    IN in_flower_name VARCHAR(50),
    IN in_flower_meaning VARCHAR(50),
    IN in_color_id INT,
    OUT out_flower_id INT)
BEGIN
    INSERT INTO FLOWERS (NAME, MEANING, COLOR_ID)
    VALUES (in_flower_name, in_flower_meaning, in_color_id );

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into out_flower_id;

    -- Display the ID of the last inserted flower.
    SELECT LAST_INSERT_ID() AS 'New flower inserted: ';
END //
DELIMITER ;

-- To update from the FLOWERS table
DROP PROCEDURE IF EXISTS sp_update_flower;
DELIMITER //
CREATE PROCEDURE sp_update_flower(
    IN in_flower_id INT,
    IN in_flower_name VARCHAR(50),
    IN in_flower_meaning VARCHAR(50),
    IN in_color_id INT)
BEGIN
    UPDATE FLOWERS AS F
    SET F.NAME=in_flower_name, F.MEANING=in_flower_meaning, F.COLOR_ID = in_color_id
    WHERE F.FLOWER_ID=in_flower_id;

END //
DELIMITER ;

-- To delete from the FLOWERS table
DROP PROCEDURE IF EXISTS sp_delete_flower;
DELIMITER //
CREATE PROCEDURE sp_delete_flower(IN in_flower_id INT)
BEGIN
    DECLARE error_message VARCHAR(255);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
            -- Rollback if failure in any statement and show failure message
        ROLLBACK;
        SELECT 'Error. Rollback triggered.' AS Result;
    END;

    -- Initiate transaction
    START TRANSACTION;
        DELETE FROM `FLOWERS` WHERE FLOWER_ID = in_flower_id;

        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in FLOWERS table for id: ', in_flower_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    -- Commit transaction and show success message
    COMMIT;
    SELECT 'Flower successfully deleted' AS Result;
END //
DELIMITER ;
