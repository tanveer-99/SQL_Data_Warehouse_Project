-- calculate the key metrics of the business (big numbers)
-- highest level of aggregation | lowest level of details

-- find the total sales
SELECT 
SUM(sales_amount) AS total_sales
FROM gold.fact_sales

-- find how many items are sold
SELECT 
SUM(quantity) AS total_items_sold
FROM gold.fact_sales


-- find the average selling price
SELECT 
AVG(price) AS avg_price
FROM gold.fact_sales

-- find the total number of orders
SELECT 
COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales

-- find the total number of products
SELECT 
COUNT(DISTINCT product_key) AS total_products
FROM gold.fact_sales

-- find the total number of customers
SELECT 
COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales

-- find the total number of customers that has placed an order
SELECT 
COUNT(DISTINCT customer_key) AS total_customers_who_placed_an_order
FROM gold.fact_sales
WHERE order_date IS NOT NULL

-- generate report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity' AS measure_name, SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price' AS measure_name, AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Number of Orders' AS measure_name, COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL 
SELECT 'total_customers_who_placed_an_order' AS measure_name ,
COUNT(DISTINCT customer_key)
FROM gold.fact_sales
WHERE order_date IS NOT NULL