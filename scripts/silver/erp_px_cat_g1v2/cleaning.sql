SELECT
*
FROM bronze.erp_px_cat_g1v2

-- check that every cat_id in the product table exists in the category table
-- Expectation: no results
SELECT *
FROM silver.crm_prod_info
WHERE cat_id NOT IN (SELECT id FROM bronze.erp_px_cat_g1v2)
-- result: one cat_id missing from crm_prod_info

SELECT DISTINCT cat FROM bronze.erp_px_cat_g1v2
SELECT DISTINCT maintenance FROM bronze.erp_px_cat_g1v2
SELECT DISTINCT subcat FROM bronze.erp_px_cat_g1v2
-- check for unwanted spaces in cat, subcat and maintenance
-- Expectation: no results
-- cat
SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat);
-- subcat
SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE subcat != TRIM(subcat);

-- maintenance
SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE maintenance != TRIM(maintenance);
