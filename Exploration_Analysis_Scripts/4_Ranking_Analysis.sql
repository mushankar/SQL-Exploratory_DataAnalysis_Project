----------------------------------------
-- RANKING ANALYSIS
----------------------------------------
/*

Order the values of dimensions by measures
TOP N performers | Bottom N performers

KEYWORDS:
TOP, RANK(), DENSE_RANK(), ROW_NUMBER()

Queries:
1. Which 5 products generate highest revenue?
2. What are 5 least performing products in terms of sales?
3. Top 10 customers who have generated highest revenue
4. Top 3 customers with the most orders places

NOTE: 
TOP keyword can easily bring the top N values after sorting the data.
However, WINDOW_FUNCTIONS are very important in case of complex and dynamic queries.

*/

----------------------------------------

-- Which 5 products generate highest revenue?

SELECT TOP 5
p.product_name,
SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC

---------------------------
-- USING WINDOW_FUNCTION
---------------------------
SELECT * FROM
(
SELECT
p.product_name,
SUM(f.sales_amount) AS total_revenue,
ROW_NUMBER() OVER(ORDER BY SUM(f.sales_amount) DESC) AS rank_products
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
) as tab
WHERE rank_products <= 5

-- What are 5 least performing products in terms of sales?

SELECT TOP 5
p.product_name,
SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue

---------------------------
-- USING WINDOW_FUNCTION
---------------------------

SELECT * FROM
(
SELECT
p.product_name,
SUM(f.sales_amount) AS total_revenue,
ROW_NUMBER() OVER(ORDER BY SUM(f.sales_amount) ASC) AS rank_products
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
) as tab
WHERE rank_products <= 5


/*

DEMO:
I've given a demo of how a nested query can be written in CTE for easier understanding.
Usually CTE or common table expressions have following syntax:

WITH giventablename AS (

SELECT 
transformed columns,
transformed columns2 as abcd
FROM TableA

)

SELECT*FROM giventablename

1. We are using the name given using WITH clause to retrieve information.
2. We can further add transformations below to get desired results.
3. giventablename table can now be reused multiple times. 

*/

-------------------------------------------------------
-- Top 10 customers who have generated highest revenue
-------------------------------------------------------

--Note: We can have 2 or more same values, so we used DENSE_RANK a Window_Function


-- Nested Query
SELECT*FROM
(
SELECT
CONCAT(c.first_name,' ',c.last_name) AS customer_name,
SUM(f.sales_amount) AS revenue_generated,
DENSE_RANK() OVER(ORDER BY SUM(f.sales_amount) DESC) AS revenue_rank
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY CONCAT(c.first_name,' ',c.last_name)
) t
WHERE revenue_rank <= 10


-- CTE query
WITH revenue_table AS
(
SELECT
CONCAT(c.first_name,' ',c.last_name) AS customer_name,
SUM(f.sales_amount) AS revenue_generated,
DENSE_RANK() OVER(ORDER BY SUM(f.sales_amount) DESC) AS revenue_rank
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY CONCAT(c.first_name,' ',c.last_name)
)

SELECT * FROM revenue_table -- We are reusing revenue_table
WHERE revenue_rank <= 10
ORDER BY revenue_rank, customer_name

-- TOP 3 Customers with most orders placed

WITH top_order_count AS
(
SELECT
c.customer_id,
CONCAT(c.first_name, ' ',c.last_name) AS fullname,
COUNT(f.order_number) AS order_count,
DENSE_RANK() OVER(ORDER BY COUNT(f.order_number) DESC) AS c_rank
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY c.customer_id,c.first_name,c.last_name
)

SELECT*FROM top_order_count
WHERE c_rank <= 3

-- Top 3 customers with most revenue generated

WITH revenue_rank_table AS (
SELECT
c.customer_id,
CONCAT(c.first_name, ' ',c.last_name) AS fullname,
SUM(sales_amount) AS revenue_generated,
COUNT(f.order_number) AS order_count,
DENSE_RANK() OVER(ORDER BY SUM(sales_amount) DESC) AS c_rank
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY c.customer_id,c.first_name,c.last_name		)

SELECT * FROM revenue_rank_table
WHERE c_rank <= 3

-- If you want to see people with most generated revenue in top 10 with most orders now
-- copy the same CTE table above

WITH revenue_rank_table AS (
SELECT
c.customer_id,
CONCAT(c.first_name, ' ',c.last_name) AS fullname,
SUM(sales_amount) AS revenue_generated,
COUNT(f.order_number) AS order_count,
DENSE_RANK() OVER(ORDER BY SUM(sales_amount) DESC) AS c_rank
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY c.customer_id,c.first_name,c.last_name		)

SELECT*FROM revenue_rank_table
WHERE c_rank <= 10
ORDER BY order_count DESC, c_rank ASC 

-- 15 orders are the highest under TOP 10 customers who have generated highest revenue

