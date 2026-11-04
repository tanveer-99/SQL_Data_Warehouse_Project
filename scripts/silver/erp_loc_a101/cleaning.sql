-- check that every cleaned cid matches a cst_key in crm_cust_info
-- Expectation: no results
SELECT REPLACE(cid, '-', '') AS cid
FROM bronze.erp_loc_a101
WHERE REPLACE(cid, '-', '') NOT IN (SELECT cst_key FROM silver.crm_cust_info);

-- data standardization
SELECT DISTINCT
cntry
FROM bronze.erp_loc_a101


-----------------------------------------


-- check that every cleaned cid matches a cst_key in crm_cust_info
-- Expectation: no results
SELECT REPLACE(cid, '-', '') AS cid
FROM silver.erp_loc_a101
WHERE REPLACE(cid, '-', '') NOT IN (SELECT cst_key FROM silver.crm_cust_info);

-- data standardization
SELECT DISTINCT
cntry
FROM silver.erp_loc_a101
