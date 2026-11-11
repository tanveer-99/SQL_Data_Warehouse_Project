-- data segmentation
-- group the data based on a specific range
-- helps understand the correlation between two measures


-- segment products into cost ranges and count how many products fall into each segment

WITH cost_range_table AS (
SELECT 
	product_key,
	product_name,
	cost,
	CASE 
		WHEN cost<100 THEN 'Below 100'
		WHEN cost BETWEEN 100 AND 500 THEN '100-500'
		WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
		ELSE 'Above 1000'
	END cost_range
FROM gold.dim_products
)

SELECT
cost_range,
COUNT(cost_range) AS total_products
FROM cost_range_table
GROUP BY cost_range
ORDER BY total_products DESC


-- task:
-- group customers into three segments based on their spending behaviour:
-- VIP: at least 12 months of history and spending more than 5000
-- Regular: at least 12 months of history and spending less than 5000
-- New: Lifespan of less than 12 months
-- And find the total number of customers by each group

WITH customer_spending_with_time AS
(
SELECT
	c.customer_id,
	SUM(f.sales_amount) AS spending,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS customer_lifespan,
	CASE 
		WHEN DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) >=12 AND SUM(f.sales_amount)>5000 THEN 'VIP'
		WHEN DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) >=12 AND SUM(f.sales_amount)<=5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_category
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON c.customer_key=f.customer_key
GROUP BY 
	c.customer_id
)

SELECT
customer_category,
COUNT(customer_category) AS total_customers
FROM customer_spending_with_time
GROUP BY customer_category
ORDER BY total_customers DESC
