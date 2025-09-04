------------------------------------------------
-- DATABASE EXPLORATION
------------------------------------------------

-- Explore all tables in the database

SELECT*FROM INFORMATION_SCHEMA.TABLES;

SELECT*FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'gold'

SELECT*FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'silver' -- NONE

-- Explore all columns in the database

SELECT*FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';

SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products'

SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales'

SELECT COLUMN_NAME, TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME LIKE '%date%'
ORDER BY 2,1


------------------------------------------------
-- DIMENSION EXPLORATION

/* 
1. Identifying unique values in each dimension
2. Recognizing how data is grouped.
*/
------------------------------------------------


-- Exploring countries

SELECT DISTINCT country 
FROM gold.dim_customers

-- Exploring Categories

SELECT DISTINCT 
category, subcategory, product_name 
FROM gold.dim_products
WHERE category IS NOT NULL
ORDER BY 1,2,3

------------------------------------------------
-- DATE EXPLORATION

/* 
1. Identifying earliest and latest dates
2. understand scope of data and the timespan
*/
------------------------------------------------

-- Find the data of first and last order_date

SELECT * FROM gold.fact_sales

SELECT 
MIN(order_date) first_order_date,
MAX(order_date) last_order_date
FROM gold.fact_sales

-- Number of products purchased in given quantity

SELECT quantity,COUNT(*) 
FROM gold.fact_sales
GROUP BY quantity

-- Years,months,days of sales available

SELECT
DATEDIFF(year,MIN(order_date),MAX(order_date)) AS order_range_years,
DATEDIFF(month,MIN(order_date),MAX(order_date)) AS order_range_months,
DATEDIFF(day,MIN(order_date),MAX(order_date)) AS order_range_days
FROM gold.fact_sales

-- Find youngest and oldest customer

SELECT * FROM gold.dim_customers

-- TOP 2 oldest customers

SELECT TOP 2
customer_id, CONCAT(first_name,' ',last_name) full_name,
DATEDIFF(Year,birthdate,GETDATE()) AS diff
FROM gold.dim_customers
ORDER BY DATEDIFF(day,birthdate,GETDATE()) DESC

-- TOP 2 youngest customers

SELECT TOP 2
birthdate, CONCAT(first_name,' ', last_name) full_name,
DATEDIFF(Year,birthdate,GETDATE()) AS diff
FROM gold.dim_customers
WHERE birthdate IS NOT NULL
ORDER BY DATEDIFF(day,birthdate,GETDATE()) ASC

-- Youngest and oldest birthdates

SELECT 
MIN(birthdate) AS oldest,
MAX(birthdate) AS youngest
FROM gold.dim_customers

------------------------------------------------
-- MEASURE EXPLORATION

/* 
1. Key Metric of Business (Big Numbers)
2. Highest level of aggregation | Lowest level of Details
*/
------------------------------------------------

/*

1. Find total sales
2. Find number of items sold
3. Find average selling price
4. Find total number of orders
5. Find total number of products
6. Find total number of customers
7. Find total number of customers that have placed orders

*/

--Find total sales
SELECT SUM(sales_amount) total_sales FROM gold.fact_sales

--Find number of items sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales

--Find average selling price
SELECT AVG(price) AS avg_price FROM gold.fact_sales

--Find total number of orders
SELECT COUNT(order_number) FROM gold.fact_sales
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales -- an order can have multiple items

--Find total number of products
SELECT COUNT(DISTINCT product_key) AS total_products FROM gold.dim_products

--Find total number of customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers

--Find total number of customers that have placed orders
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.fact_sales

--------------------------------------------------------------------
-- HEAD TO KEY METRICS REPORT to SEE ALL THE ABOVE KPI's in a TABLE
--------------------------------------------------------------------