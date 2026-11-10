-- comparing the current value with a target value
-- helps measure success and compare performance

-- analyse the yearly performance of products by comparing each products sales
-- to both its average sales performance and the previous years sales

WITH yearly_product_sales AS (
SELECT 
YEAR(f.order_date) AS order_year,
p.product_name,
SUM(f.sales_amount) AS current_sales
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON p.product_key = f.product_key
WHERE f.order_date IS NOT NULL
GROUP BY 
YEAR(f.order_date),
p.product_name
)

SELECT 
order_year,
product_name,
current_sales,
AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales,
current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_avg,
CASE
    WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
    WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
    ELSE 'Avg'
END AS avg_change,
LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS py_sales,
-- year over year analysis
current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS diff_py_sales,
CASE
    WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
    WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
    ELSE 'No change'
END AS py_change
FROM yearly_product_sales
ORDER BY product_name, order_year




-- analyse the monthly performance of products by comparing each product's sales
-- to both its average monthly sales and the previous month's sales

WITH monthly_product_sales AS (
    SELECT
        DATEFROMPARTS(YEAR(f.order_date), MONTH(f.order_date), 1) AS order_month,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_products AS p
        ON p.product_key = f.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY
        DATEFROMPARTS(YEAR(f.order_date), MONTH(f.order_date), 1),
        p.product_name
)
SELECT
    FORMAT(order_month, 'yyyy-MMMM') AS order_month_name,
    product_name,
    current_sales,
    AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
    CASE
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_change,
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_month) AS pm_sales,
    -- month over month analysis
    current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_month) AS diff_pm_sales,
    CASE
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_month) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_month) < 0 THEN 'Decrease'
        ELSE 'No change'
    END AS pm_change
FROM monthly_product_sales
ORDER BY product_name, order_month;
