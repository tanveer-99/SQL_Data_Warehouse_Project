-- identify the latest and earliest dates (boundaries).

-- understand the scope of data and the timespan.

-- find the date of the first and last order
SELECT 
MIN(order_date) AS first_order_date,
MAX(order_date) AS last_order_date
FROM gold.fact_sales

-- how many years of sales are available
SELECT 
MIN(order_date) AS first_order_date,
MAX(order_date) AS last_order_date,
DATEDIFF(year, MIN(order_date), MAX(order_date)) AS order_range_years
FROM gold.fact_sales

-- find the youngest and the oldest customers
SELECT 
MIN(birth_date) AS oldest_customer,
MAX(birth_date) AS youngest_customer,
DATEDIFF(year, MIN(birth_date), GETDATE()) AS oldest_age,
DATEDIFF(year, MAX(birth_date), GETDATE()) AS youngest_age
FROM gold.dim_customers
