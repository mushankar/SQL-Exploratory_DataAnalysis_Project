
------------------------------------------------
------------------------------------------------
-- GENERATE A REPORT THAT SHOWS ALL KEY METRICS OF THE BUSINESS

------------------------------------------------
------------------------------------------------

SELECT 
'total_customers' as measure_name, 
COUNT(DISTINCT customer_key) AS meaure_value 
FROM gold.fact_sales

UNION ALL

SELECT 'customers_with_orders' as measure_name,
COUNT(customer_key) AS measure_value 
FROM gold.dim_customers

UNION ALL

SELECT 'total_products' as measure_name,
COUNT(DISTINCT product_key) AS meaure_value 
FROM gold.dim_products

UNION ALL

SELECT 'total_orders' AS measure_name,
COUNT(DISTINCT order_number) AS measure_value 
FROM gold.fact_sales

UNION ALL

SELECT 'avg_price' AS measure_name,
AVG(price) AS measure_value 
FROM gold.fact_sales

UNION ALL

SELECT 'total_quantity' AS measure_name,
SUM(quantity) AS measure_value 
FROM gold.fact_sales

UNION ALL

SELECT 'total_sales' AS measure_name,
SUM(sales_amount) AS measure_value 
FROM gold.fact_sales


--------------------------------------------------------------------
-- HEAD TO MAGNITUDE ANALYSIS to do further exciting EDA
--------------------------------------------------------------------





