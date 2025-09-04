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
4. Top 3 customers with the fewest orders places

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


