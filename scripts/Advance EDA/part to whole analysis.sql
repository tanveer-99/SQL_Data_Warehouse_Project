-- part to whole analysis, proportion analysis
-- analyse how an individual part is performing compared to the overall
-- allowing us to understand which category has the greatest impact on the business


-- Which categories contribute most to the overall sales
WITH category_sales AS (
SELECT
	p.category,
	SUM(sales_amount) AS total_sales_per_product 
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
	ON p.product_key = f.product_key
GROUP BY p.category
)

SELECT 
	category,
	total_sales_per_product,
	SUM(total_sales_per_product) OVER() AS overall_sales,
	CONCAT(ROUND(((CAST(total_sales_per_product AS FLOAT)/SUM(total_sales_per_product) OVER()) *100), 2),'%') AS percentage_of_total
FROM category_sales
ORDER BY percentage_of_total DESC
