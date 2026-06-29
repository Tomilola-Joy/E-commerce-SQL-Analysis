--PART 1 = DATA CLEANING FOR TRADEZONE DATABASE---

--1.1 handling null emails in customers

UPDATE customers
SET email = 'unknown@email.com'
WHERE email IS NULL OR TRIM(email) = '';


--1.2 handling null unit_price in order_items

UPDATE order_items
SET unit_price = 0
WHERE unit_price IS NULL;


--1.3 handling null total_amount in orders

SELECT COUNT(*) AS null_total_amounts
FROM orders
WHERE total_amount IS NULL;


--1.4 handling null delivery_date in orders

SELECT order_status, COUNT(*) AS count
FROM orders
WHERE delivery_date IS NULL
GROUP BY order_status
ORDER BY count DESC;


--1.5 check for duplicate rows in customers, sellers, and orders

SELECT customer_id, COUNT(*) AS count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT seller_id, COUNT(*) AS count
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;

SELECT order_id, COUNT(*) AS count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

--1.6 standardize city names in customers and sellers
UPDATE customers
SET city = INITCAP(TRIM(city));

UPDATE sellers
SET city = INITCAP(TRIM(city));

UPDATE customers
SET city = 'Lagos'
WHERE TRIM(city) ILIKE 'lago s';

UPDATE sellers
SET city = 'Lagos'
WHERE TRIM(city) ILIKE 'lago s';

UPDATE customers
SET city = 'Port Harcourt'
WHERE TRIM(city) ILIKE 'portharcourt'
   OR TRIM(city) ILIKE 'port-harcourt';

UPDATE sellers
SET city = 'Port Harcourt'
WHERE TRIM(city) ILIKE 'portharcourt'
   OR TRIM(city) ILIKE 'port-harcourt';

--1.7 Change Product Categories to Title Case
SELECT * FROM products;

UPDATE products
SET category = INITCAP(TRIM(category));

UPDATE products
SET category = 'Electronics'
WHERE category ILIKE 'Electronis';

UPDATE products
SET category = 'Electronics'
WHERE category IN ('Electronics', 'ELECTRONICS', 'electronics');

UPDATE products
SET category = 'Fashion'
WHERE category IN ('Fashion', 'FASHION', 'fashion', 'Fashon');

UPDATE products
SET category = 'Food & Beverages'
WHERE category IN ('Food', 'FOOD', 'food', 'Food And Beverages');

UPDATE products
SET category = 'Books & Stationery'
WHERE category IN ('Books', 'books', 'Books And Stationery');

UPDATE products
SET category = 'Sports & Fitness'
WHERE category IN ('Sports', 'sports', 'Sports And Fitness');

UPDATE products
SET category = 'Beauty & Personal Care'
WHERE category IN ('Beauty', 'Beauty And Personal Care');

UPDATE products
SET category = 'Home & Garden'
WHERE category IN ('Home And Garden');

--1.8 Validate total_amount vs order_items if there is an errors present there
SELECT 
    o.order_id,
    o.total_amount,
    SUM(oi.line_total) AS computed_total,
    ABS(o.total_amount - SUM(oi.line_total)) AS difference
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.total_amount
HAVING ABS(o.total_amount - SUM(oi.line_total)) > 10;

ALTER TABLE orders
ADD COLUMN amount_mismatch_flag BOOLEAN;

UPDATE orders o
SET amount_mismatch_flag = TRUE
FROM (
    SELECT 
        o.order_id
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id, o.total_amount
    HAVING ABS(o.total_amount - SUM(oi.line_total)) > 10
) sub
WHERE o.order_id = sub.order_id;

UPDATE orders
SET amount_mismatch_flag = FALSE
WHERE amount_mismatch_flag IS NULL;

SELECT amount_mismatch_flag, COUNT(*)
FROM orders
GROUP BY amount_mismatch_flag;

--1.9 Validate Review Ratings (1–5)
SELECT *
FROM reviews
WHERE rating < 1 OR rating > 5;

UPDATE reviews
SET rating = NULL
WHERE rating < 1 OR rating > 5;

ALTER TABLE reviews
ADD CONSTRAINT check_rating
CHECK (rating BETWEEN 1 AND 5);

--1.10 Check if there are any negative prices or discounts
SELECT *
FROM products
WHERE unit_price < 0;

UPDATE products
SET unit_price = NULL
WHERE unit_price < 0;

ALTER TABLE products
ADD CONSTRAINT check_unit_price
CHECK (unit_price >= 0);

--1.11. discount percentages above 100%
--It does not exist in the database and writing code for it would bring up error in the query.
