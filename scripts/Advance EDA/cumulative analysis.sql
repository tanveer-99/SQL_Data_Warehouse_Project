-- cumulative analysis
-- Aggregate the data progressively over time.
-- Helps to understand whether our business is growing or declining.


-- calculate the total sales per month
-- and the running total of sales over time

SELECT
order_year,
order_month,
total_sales,
SUM(total_sales) OVER(ORDER BY order_year, order_month_number) AS running_total_sales
FROM 
(
SELECT
YEAR(order_date) AS order_year,
MONTH(order_date) AS order_month_number,
DATENAME(MONTH, order_date)  AS order_month,
SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date), DATENAME(MONTH, order_date)
) t
ORDER BY order_year, order_month_number


-- and the running total of sales in each year

SELECT
order_year,
order_month,
total_sales,
SUM(total_sales) OVER(PARTITION BY order_year ORDER BY order_year, order_month_number) AS running_total_sales_in_each_year
FROM 
(
SELECT
YEAR(order_date) AS order_year,
MONTH(order_date) AS order_month_number,
DATENAME(MONTH, order_date)  AS order_month,
SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date), DATENAME(MONTH, order_date)
) t
ORDER BY order_year, order_month_number
