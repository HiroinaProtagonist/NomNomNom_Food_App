-- Citation for the following code:
-- Date: 3/1/2026
-- Adapted from PL/SQL assignment starter code and Step 4 Draft starter code
-- (https://canvas.oregonstate.edu/courses/2031764/assignments/10323329?module_item_id=26243433,
-- https://canvas.oregonstate.edu/courses/2031764/assignments/10323339?module_item_id=26243440)
-- Changes made beyond the starter code are our own without reference to AI

-- Citation for Flower Meanings: http://www.allflorists.co.uk/advice_flowerMeanings.asp

-- CALL DDL STATEMENTS TO RESET TABLES AND DATA
-- DDL Group 126

-- SEE DDL.SQL FOR RESET/SAMPLE DATA STORED PROCEDURE

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

------------------------------------------------------------------------------------
-- To create/insert into the BOUQUETS table
DROP PROCEDURE IF EXISTS sp_create_bouquet;
DELIMITER //
CREATE PROCEDURE sp_create_bouquet(
    IN in_bouquet_name VARCHAR(50),
    IN in_bouquet_description VARCHAR(50),
    IN in_maker_id INT,
    IN in_recipient_id INT,
    OUT out_flower_id INT)
BEGIN
    INSERT INTO BOUQUETS (NAME, DESCRIPTION, MAKER_ID, RECIPIENT_ID)
    VALUES (in_bouquet_name, in_bouquet_description, in_maker_id, in_recipient_id );

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into out_flower_id;

-- Display the ID of the last inserted flower.
SELECT LAST_INSERT_ID() AS 'New flower inserted: ';
END //
DELIMITER ;

-- To create/insert into the BOUQUET table with flowers
-- https://www.geeksforgeeks.org/sql/mysql-while-loop/
DROP PROCEDURE IF EXISTS sp_create_with_flowers_bouquet;
DELIMITER //
CREATE PROCEDURE sp_create_bouquet(
    IN in_flower_count INT,
    IN in_flower_id INT,
    IN in_bouquet_name VARCHAR(50),
    IN in_bouquet_description VARCHAR(50),
    IN in_maker_id INT,
    IN in_recipient_id INT,
    OUT out_bouquet_id INT)
BEGIN
--     DECLARE created INT;
    DECLARE num_flowers;
    SET num_flowers = in_flower_count;
    DECLARE error_message VARCHAR(255);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error. Rollback triggered.' AS Result;
    END;
    START TRANSACTION;
        INSERT INTO BOUQUETS (NAME, DESCRIPTION, MAKER_ID, RECIPIENT_ID)
        VALUES (in_bouquet_name, in_bouquet_description, in_maker_id, in_recipient_id );

        -- Store the ID of the last inserted row
        SELECT LAST_INSERT_ID() into out_bouquet_id;
--         SELECT LAST_INSERT_ID() into created;

        -- Display the ID of the last inserted bouquet.
        SELECT LAST_INSERT_ID() AS 'created_id';

        label:
             WHILE num_flowers > 0 DO
                INSERT INTO FLOWERS_BOUQUETS (FLOWER_ID, BOUQUET_ID)
                VALUES (in_flower_id, out_bouquet_id);
    COMMIT;
    SELECT 'Bouquet successfully updated' AS Result;
END //
DELIMITER ;

-- To add flowers to the FLOWERS_BOUQUETS intersection table
DROP PROCEDURE IF EXISTS sp_add_ftob;
DELIMITER //
CREATE PROCEDURE sp_add_ftob(
    IN in_flower_id INT,
    IN in_bouquet_id INT)
BEGIN
-- The following code references the following
-- Source URL:
-- https://www.scaler.com/topics/mysql-insert-if-not-exists/
    INSERT IGNORE INTO FLOWERS_BOUQUETS (FLOWER_ID, BOUQUET_ID)
    VALUES (in_flower_id, in_bouquet_id );
END //
DELIMITER ;

-- To update from the BOUQUET table
DROP PROCEDURE IF EXISTS sp_update_bouquet;
DELIMITER //
CREATE PROCEDURE sp_update_bouquet(
    IN in_bouquet_id INT,
    IN in_bouquet_name VARCHAR(50),
    IN in_bouquet_description VARCHAR(50),
    IN in_maker_id INT,
    IN in_recipient_id INT)
BEGIN
UPDATE BOUQUETS AS B
SET B.NAME=in_bouquet_name, B.DESCRIPTION=in_bouquet_description,
    B.MAKER_ID=in_maker_id, B.RECIPIENT_ID=in_recipient_id
WHERE B.BOUQUET_ID=in_bouquet_id;

END //
DELIMITER ;

-- To delete from the BOUQUET table
DROP PROCEDURE IF EXISTS sp_delete_bouquet;
DELIMITER //
CREATE PROCEDURE sp_delete_bouquet(IN in_bouquet_id INT)
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
        DELETE FROM BOUQUETS WHERE BOUQUET_ID = in_bouquet_id;

        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found for id: ', in_bouquet_id);

            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    -- Commit transaction and show success message
    COMMIT;
    SELECT 'Bouquet successfully deleted' AS Result;
END //
DELIMITER ;

-- To delete given flower from the FLOWERS_BOUQUETS table for given bouquet
DROP PROCEDURE IF EXISTS sp_delete_bouquet_flower;
DELIMITER //
CREATE PROCEDURE sp_delete_bouquet_flower(
    IN in_flower_id INT,
    IN in_bouquet_id INT)
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
            DELETE FROM FLOWERS_BOUQUETS WHERE BOUQUET_ID = in_bouquet_id AND FLOWER_ID = in_flower_id;

            -- ROW_COUNT() returns the number of rows affected by the preceding statement.
            IF ROW_COUNT() = 0 THEN
                set error_message = CONCAT('No matching record found for bouquet: ',
                in_bouquet_id, ' and flower: ', in_flower_id);

                -- Trigger custom error, invoke EXIT HANDLER
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
            END IF;

        -- Commit transaction and show success message
        COMMIT;
        SELECT 'Flower successfully deleted from bouquet' AS Result;
    END //
DELIMITER ;
