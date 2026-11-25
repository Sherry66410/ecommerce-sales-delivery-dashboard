CREATE DATABASE IF NOT EXISTS olist_ecommerce;
USE olist_ecommerce;
SET FOREIGN_KEY_CHECKS = 0;

/* ---------- 1. customers ---------- */
DROP TABLE IF EXISTS olist_customers;
CREATE TABLE olist_customers (
    customer_id             CHAR(32) PRIMARY KEY,  
    customer_unique_id      CHAR(32),               
    customer_zip_code_prefix INT,
    customer_city           VARCHAR(50),
    customer_state          CHAR(2)
);

/* ---------- 2. geolocation ---------- */
DROP TABLE IF EXISTS olist_geolocation;
CREATE TABLE olist_geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat  DECIMAL(10,6),
    geolocation_lng  DECIMAL(10,6),
    geolocation_city VARCHAR(50),
    geolocation_state CHAR(2)
);

/* ---------- 3. orders  ---------- */
DROP TABLE IF EXISTS olist_orders;
CREATE TABLE olist_orders (
    order_id                       CHAR(32) PRIMARY KEY,
    customer_id                    CHAR(32),
    order_status                   VARCHAR(20),
    order_purchase_timestamp       DATETIME,
    order_approved_at              DATETIME,
    order_delivered_carrier_date   DATETIME,
    order_delivered_customer_date  DATETIME,
    order_estimated_delivery_date  DATETIME
);

/* ---------- 4. order_items  ---------- */
DROP TABLE IF EXISTS olist_order_items;
CREATE TABLE olist_order_items (
    order_id            CHAR(32),
    order_item_id        INT,
    product_id           CHAR(32),
    seller_id            CHAR(32),
    shipping_limit_date   DATETIME,
    price                DECIMAL(10,2),
    freight_value        DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id)   
);

/* ---------- 5. order_payments ---------- */
DROP TABLE IF EXISTS olist_order_payments;
CREATE TABLE olist_order_payments (
    order_id             CHAR(32),
    payment_sequential   INT,
    payment_type         VARCHAR(20),
    payment_installments INT,
    payment_value        DECIMAL(10,2),
    PRIMARY KEY (order_id, payment_sequential)  
);

/* ---------- 6. order_reviews ---------- */
DROP TABLE IF EXISTS olist_order_reviews;
CREATE TABLE olist_order_reviews (
    review_id               CHAR(32),
    order_id                CHAR(32),
    review_score            INT,
    review_comment_title    VARCHAR(150),
    review_comment_message  TEXT,
    review_creation_date    DATETIME,
    review_answer_timestamp DATETIME
);

/* ---------- 7. products ---------- */
DROP TABLE IF EXISTS olist_products;
CREATE TABLE olist_products (
    product_id               CHAR(32) PRIMARY KEY,
    product_category_name    VARCHAR(50),
    product_name_lenght      INT,
    product_description_lenght INT,
    product_photos_qty       INT,
    product_weight_g         INT,
    product_length_cm        INT,
    product_height_cm        INT,
    product_width_cm         INT
);

/* ---------- 8. sellers ---------- */
DROP TABLE IF EXISTS olist_sellers;
CREATE TABLE olist_sellers (
    seller_id             CHAR(32) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city           VARCHAR(50),
    seller_state          CHAR(2)
);

/* ---------- 9. category  ---------- */
DROP TABLE IF EXISTS product_category_translation;
CREATE TABLE product_category_translation (
    product_category_name         VARCHAR(50) PRIMARY KEY,
    product_category_name_english VARCHAR(50)
);

SET FOREIGN_KEY_CHECKS = 1;

/* NOTE: The LOAD DATA INFILE paths below are local to my machine.
   Before running, change them to the folder where you saved the Olist CSVs.
   The folder must be allowed by MySQL's secure_file_priv setting
   (check it with: SHOW VARIABLES LIKE 'secure_file_priv';). */

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_customers_dataset.csv'
INTO TABLE olist_customers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_geolocation_dataset.csv'
INTO TABLE olist_geolocation
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_orders_dataset.csv'
INTO TABLE olist_orders
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, customer_id, order_status,
 @purchase, @approved, @carrier, @delivered, @estimated)
SET
 order_purchase_timestamp      = NULLIF(@purchase,''),
 order_approved_at             = NULLIF(@approved,''),
 order_delivered_carrier_date  = NULLIF(@carrier,''),
 order_delivered_customer_date = NULLIF(@delivered,''),
 order_estimated_delivery_date = NULLIF(@estimated,'');

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_items_dataset.csv'
INTO TABLE olist_order_items
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_payments_dataset.csv'
INTO TABLE olist_order_payments
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_reviews_dataset.csv'
INTO TABLE olist_order_reviews
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(review_id, order_id, review_score, review_comment_title,
 review_comment_message, @created, @answered)
SET
 review_creation_date    = NULLIF(@created,''),
 review_answer_timestamp = NULLIF(@answered,'');

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_products_dataset.csv'
INTO TABLE olist_products
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_id, @category, @name_len, @desc_len, @photos,
 @weight, @length, @height, @width)
SET
 product_category_name      = NULLIF(@category,''),
 product_name_lenght        = NULLIF(@name_len,''),
 product_description_lenght = NULLIF(@desc_len,''),
 product_photos_qty         = NULLIF(@photos,''),
 product_weight_g           = NULLIF(@weight,''),
 product_length_cm          = NULLIF(@length,''),
 product_height_cm          = NULLIF(@height,''),
 product_width_cm           = NULLIF(@width,'');

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_sellers_dataset.csv'
INTO TABLE olist_sellers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product_category_name_translation.csv'
INTO TABLE product_category_translation
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT 'customers' AS tbl, COUNT(*) AS rows_loaded FROM olist_customers
UNION ALL SELECT 'geolocation', COUNT(*) FROM olist_geolocation
UNION ALL SELECT 'orders', COUNT(*) FROM olist_orders
UNION ALL SELECT 'order_items', COUNT(*) FROM olist_order_items
UNION ALL SELECT 'order_payments', COUNT(*) FROM olist_order_payments
UNION ALL SELECT 'order_reviews', COUNT(*) FROM olist_order_reviews
UNION ALL SELECT 'products', COUNT(*) FROM olist_products
UNION ALL SELECT 'sellers', COUNT(*) FROM olist_sellers
UNION ALL SELECT 'category_translation', COUNT(*) FROM product_category_translation;



