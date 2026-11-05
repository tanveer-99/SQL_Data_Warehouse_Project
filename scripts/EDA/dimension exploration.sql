-- identifying the unique values (or categories) in each dimension.
-- recognizing how data might be grouped or segmented, which is useful for later analysis

-- explore all countries that our customers come from
SELECT DISTINCT 
country
FROM gold.dim_customers

-- explore all categories "the major divisions"
SELECT DISTINCT
category, subcategory, product_name
FROM gold.dim_products
ORDER BY 1,2,3
