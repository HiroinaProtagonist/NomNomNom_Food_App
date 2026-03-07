-- Citation for the following code:
-- Date: 3/1/2026
-- Adapted from PL/SQL assignment starter code and Step 4 Draft starter code
-- (https://canvas.oregonstate.edu/courses/2031764/assignments/10323329?module_item_id=26243433,
-- https://canvas.oregonstate.edu/courses/2031764/assignments/10323339?module_item_id=26243440)
-- Changes made beyond the starter code are our own without reference to AI

-- CALL DDL STATEMENTS TO RESET TABLES AND DATA
DROP PROCEDURE IF EXISTS sp_ddl;
DELIMITER //
CREATE PROCEDURE sp_ddl()
BEGIN
    SET FOREIGN_KEY_CHECKS=0;
    SET AUTOCOMMIT = 0;

    DROP TABLE IF EXISTS FOOD_ITEMS_ORDERS;
    DROP TABLE IF EXISTS ORDERS;
    DROP TABLE IF EXISTS FOOD_ITEMS;
    DROP TABLE IF EXISTS RESTAURANTS;
    DROP TABLE IF EXISTS CUSTOMERS;

    CREATE TABLE RESTAURANTS (
    RESTAURANT_ID INT(11) AUTO_INCREMENT NOT NULL,
    RATING DECIMAL NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    PHONE_NUMBER VARCHAR(10),
    ADDRESS VARCHAR(255) NOT NULL,
    EMAIL VARCHAR(255),
    PRIMARY KEY (RESTAURANT_ID)
    );

    CREATE TABLE CUSTOMERS (
    CUSTOMER_ID INT(11) AUTO_INCREMENT NOT NULL,
    FIRST_NAME VARCHAR(255) NOT NULL,
    LAST_NAME VARCHAR(255) NOT NULL,
    PHONE_NUMBER VARCHAR(10),
    ADDRESS VARCHAR(255) NOT NULL,
    EMAIL VARCHAR(255) NOT NULL,
    PRIMARY KEY (CUSTOMER_ID)
    );

    CREATE TABLE ORDERS (
    ORDER_ID INT(11) AUTO_INCREMENT NOT NULL,
    ORDER_DATE DATE NOT NULL,
    CUSTOMER_ID INT(11) NOT NULL,
    RESTAURANT_ID INT(11) NOT NULL,
    TOTAL_PRICE DECIMAL(6,2) NOT NULL,
    PAYMENT_STATUS BOOLEAN NOT NULL,
    FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMERS(CUSTOMER_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (RESTAURANT_ID) REFERENCES RESTAURANTS(RESTAURANT_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (ORDER_ID)
    );

    CREATE TABLE FOOD_ITEMS (
    FOOD_ITEM_ID INT(11) AUTO_INCREMENT NOT NULL,
    RESTAURANT_ID INT(11) NOT NULL,
    NAME VARCHAR(255) NOT NULL,
    PRICE DECIMAL(6,2)  NOT NULL,
    FOREIGN KEY (RESTAURANT_ID) REFERENCES RESTAURANTS(RESTAURANT_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (FOOD_ITEM_ID)
    );

    CREATE TABLE FOOD_ITEMS_ORDERS (
    FOOD_ITEM_ID INT(11) NOT NULL,
    ORDER_ID INT(11) NOT NULL,
    FOREIGN KEY (FOOD_ITEM_ID) REFERENCES FOOD_ITEMS(FOOD_ITEM_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ORDER_ID) REFERENCES ORDERS(ORDER_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (ORDER_ID, FOOD_ITEM_ID)
    );

    INSERT INTO CUSTOMERS (FIRST_NAME, LAST_NAME, PHONE_NUMBER, ADDRESS, EMAIL)
    VALUES
        ('Joe', 'Schmo', '5036872456',
         '1 Happy St, Corvallis, OR 97330', 'joeschmo@gmail.com'),
        ('Sarah', 'Gavonel', '5031948388',
         '434 Constant Ave, Corvallis, OR 97330', 'sarahgavonel@yahoo.com'),
        ('Fatima', 'Khan', '5034575642',
         '935 MLK Way, Corvallis, OR 97330', 'fatimakhan@gmail.com');

    INSERT INTO RESTAURANTS (RATING, NAME, PHONE_NUMBER, ADDRESS, EMAIL)
    VALUES
        (4.2, 'Duffies', '5032354485',
         '123 NW Jackson Ave, Corvallis, OR 97330', 'duffies@aol.net'),
        (4.8, 'Razorback Pit BBQ', '5031235489',
         '1569 NW Monroe Ave, Corvallis, OR 97330', 'razorbackbbq@razor.com'),
        (3.3, 'McDonalds', '5038763365', '300 NW 3rd St, Corvallis, OR 97330', NULL);

    INSERT INTO FOOD_ITEMS (RESTAURANT_ID, NAME, PRICE)
    VALUES
        ((SELECT RESTAURANT_ID FROM RESTAURANTS WHERE RESTAURANTS.NAME = 'Duffies'),
         'Hamburger', 8.99),
        ((SELECT RESTAURANT_ID FROM RESTAURANTS WHERE RESTAURANTS.NAME = 'Razorback Pit BBQ'),
         'Ribs', 15.99),
        ((SELECT RESTAURANT_ID FROM RESTAURANTS WHERE RESTAURANTS.NAME = 'McDonalds'),
         'French Fries', 3.99);

    INSERT INTO ORDERS (ORDER_DATE, CUSTOMER_ID, RESTAURANT_ID, TOTAL_PRICE, PAYMENT_STATUS)
    VALUES
        ('2026-01-03', (SELECT CUSTOMER_ID FROM CUSTOMERS WHERE CUSTOMERS.FIRST_NAME = 'Sarah'
                                                            AND CUSTOMERS.LAST_NAME = 'Gavonel'),
         (SELECT RESTAURANT_ID FROM RESTAURANTS WHERE RESTAURANTS.NAME = 'Razorback Pit BBQ'),
         15.99, TRUE),
        ('2026-01-09', (SELECT CUSTOMER_ID FROM CUSTOMERS WHERE CUSTOMERS.FIRST_NAME = 'Fatima'
                                                            AND CUSTOMERS.LAST_NAME = 'Khan'),
         (SELECT RESTAURANT_ID FROM RESTAURANTS WHERE RESTAURANTS.NAME = 'Razorback Pit BBQ'),
         15.99, TRUE),
        ('2026-01-10', (SELECT CUSTOMER_ID FROM CUSTOMERS WHERE CUSTOMERS.FIRST_NAME = 'Joe'
                                                            AND CUSTOMERS.LAST_NAME = 'Schmo'),
         (SELECT RESTAURANT_ID FROM RESTAURANTS WHERE RESTAURANTS.NAME = 'Duffies'),
         8.99, TRUE);

    INSERT INTO FOOD_ITEMS_ORDERS (FOOD_ITEM_ID, ORDER_ID)
    VALUES
        ((SELECT FOOD_ITEM_ID FROM FOOD_ITEMS WHERE FOOD_ITEMS.NAME = 'Ribs'),
         (SELECT ORDER_ID FROM ORDERS JOIN CUSTOMERS ON ORDERS.CUSTOMER_ID = CUSTOMERS.CUSTOMER_ID
          WHERE CUSTOMERS.FIRST_NAME = 'Sarah')),
        ((SELECT FOOD_ITEM_ID FROM FOOD_ITEMS WHERE FOOD_ITEMS.NAME = 'Ribs'),
         (SELECT ORDER_ID FROM ORDERS JOIN CUSTOMERS ON ORDERS.CUSTOMER_ID = CUSTOMERS.CUSTOMER_ID
          WHERE CUSTOMERS.FIRST_NAME = 'Fatima')),
        ((SELECT FOOD_ITEM_ID FROM FOOD_ITEMS WHERE FOOD_ITEMS.NAME = 'Hamburger'),
         (SELECT ORDER_ID FROM ORDERS JOIN CUSTOMERS ON ORDERS.CUSTOMER_ID = CUSTOMERS.CUSTOMER_ID
          WHERE CUSTOMERS.FIRST_NAME = 'Joe'));
    SET FOREIGN_KEY_CHECKS=1;
    COMMIT;
END //
DELIMITER ;

-- To demonstrate RESET
DROP PROCEDURE IF EXISTS sp_delete_french_fries;
DELIMITER //
CREATE PROCEDURE sp_delete_french_fries()
BEGIN
    DECLARE fry_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback if failure in any statement and show failure message
        ROLLBACK;
        SELECT 'Error. Rollback triggered.' AS Result;
    END;

    -- Initiate transaction to delete from FOOD_ITEMS and FOOD_ITEMS_ORDERS tables
    START TRANSACTION;
        -- Get item to delete and execute deletes
        SELECT FOOD_ITEM_ID INTO fry_id FROM FOOD_ITEMS WHERE NAME = 'French Fries';
        DELETE FROM `FOOD_ITEMS_ORDERS` WHERE `FOOD_ITEM_ID` = fry_id;
        DELETE FROM `FOOD_ITEMS` WHERE `FOOD_ITEM_ID` = fry_id;
    -- Commit transaction and show success message
    COMMIT;
    SELECT 'Delete of food item successful' AS Result;
END //
DELIMITER ;

-- FOOD_ITEMS CUD operations
-- To create/insert into the FOOD_ITEMS table
DROP PROCEDURE IF EXISTS sp_create_food_item;
DELIMITER //
CREATE PROCEDURE sp_create_food_item(
    IN in_restaurant_id INT,
    IN in_food_item_name VARCHAR(255),
    IN in_price DECIMAL(6,2),
    OUT out_food_item_id INT)
BEGIN
    INSERT INTO FOOD_ITEMS (RESTAURANT_ID, NAME, PRICE)
    VALUES (in_restaurant_id, in_food_item_name, in_price);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into out_food_item_id;

    -- Display the ID of the last inserted person.
    SELECT LAST_INSERT_ID() AS 'New food item inserted: ';
END //
DELIMITER ;

-- To update from the FOOD_ITEMS table
DROP PROCEDURE IF EXISTS sp_update_food_item;
DELIMITER //
CREATE PROCEDURE sp_update_food_item(
    IN in_restaurant_id INT,
    IN in_food_item_id INT,
    IN in_food_item_name VARCHAR(255),
    IN in_price DECIMAL(6,2))
BEGIN
    UPDATE FOOD_ITEMS SET RESTAURANT_ID=in_restaurant_id, FOOD_ITEM_ID=in_food_item_id,
    NAME=in_food_item_name, PRICE=in_price WHERE FOOD_ITEM_ID=in_food_item_id
    AND RESTAURANT_ID=in_restaurant_id;
END //
DELIMITER ;

-- To delete from the FOOD_ITEMS table
DROP PROCEDURE IF EXISTS sp_delete_food_item;
DELIMITER //
CREATE PROCEDURE sp_delete_food_item(
    IN in_food_item_id INT)
BEGIN
    DECLARE error_message VARCHAR(255);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
            -- Rollback if failure in any statement and show failure message
        ROLLBACK;
        SELECT 'Error. Rollback triggered.' AS Result;
    END;

    -- Initiate transaction to delete from FOOD_ITEMS and FOOD_ITEMS_ORDERS tables
    START TRANSACTION;
        DELETE FROM ORDERS
            LEFT JOIN FOOD_ITEMS_ORDERS ON FOOD_ITEMS_ORDERS.ORDER_ID = ORDERS.ORDER_ID
            WHERE FOOD_ITEMS_ORDERS.FOOD_ITEM_ID = :FOOD_ITEM_ID_FROM_FORM;

        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in FOOD_ITEMS table for id: ', in_food_item_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    -- Commit transaction and show success message
    COMMIT;
    SELECT 'Delete of food item successful' AS Result;
END //
DELIMITER ;

-- FOOD_ITEMS_ORDERS CUD operations
-- TODO Use logic to choose the correct update statement depending on whether both or either field is populated

-- To update from the FOOD_ITEMS_ORDERS table by FOOD_ITEM_ID
DROP PROCEDURE IF EXISTS sp_update_food_item_order_record;
DELIMITER //
CREATE PROCEDURE sp_update_food_item_order_record(
    IN in_food_item_id INT,
    IN in_order_id INT)
BEGIN
    UPDATE FOOD_ITEMS_ORDERS SET FOOD_ITEM_ID=in_food_item_id, ORDER_ID=in_order_id
        WHERE FOOD_ITEM_ID=in_food_item_id;
END //
DELIMITER ;

-- To delete from the FOOD_ITEMS table by food_item_id
DROP PROCEDURE IF EXISTS sp_delete_food_item_order_record;
DELIMITER //
CREATE PROCEDURE sp_delete_food_item_order_record(
    IN in_food_item_id INT,
    IN in_order_id INT
)
BEGIN
    DECLARE error_message VARCHAR(255);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback if failure in any statement and show failure message
        ROLLBACK;
        SELECT 'Error. Rollback triggered.' AS Result;
    END;

    -- Initiate transaction to delete from FOOD_ITEMS and FOOD_ITEMS_ORDERS tables
    START TRANSACTION;
        -- Get item to delete and execute deletes
        DELETE FROM `FOOD_ITEMS_ORDERS` WHERE `FOOD_ITEM_ID` = food_item_id AND `ORDER_ID` = order_id;

        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            SET error_message = CONCAT(
                'No matching record found in FOOD_ITEMS_ORDERS for given FOOD_ITEM_ID: ',
                in_food_item_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    -- Commit transaction and show success message
    COMMIT;
    SELECT 'Delete of food item successful' AS Result;
END //
DELIMITER ;

