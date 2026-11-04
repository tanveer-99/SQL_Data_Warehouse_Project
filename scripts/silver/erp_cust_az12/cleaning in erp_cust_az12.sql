-- erp_cust_az12: cid has a 'NAS' prefix that crm_cust_info.cst_key doesn't have
-- remove the prefix so the keys match
SELECT
    CASE
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
        ELSE cid
    END AS cid,
    bdate,
    gen
FROM bronze.erp_cust_az12;

-- identify out-of-range birthdates in erp_cust_az12
-- Expectation: no results
SELECT DISTINCT bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01'
   OR bdate > GETDATE();

-- check data standardisation and consistency in gen
-- Expectation: a short list of consistent values
SELECT DISTINCT gen
FROM bronze.erp_cust_az12;

--------------------------------------------------


-- erp_cust_az12: cid has a 'NAS' prefix that crm_cust_info.cst_key doesn't have
-- remove the prefix so the keys match
SELECT
    CASE
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
        ELSE cid
    END AS cid,
    bdate,
    gen
FROM silver.erp_cust_az12;

-- identify out-of-range birthdates in erp_cust_az12
-- Expectation: no results
SELECT DISTINCT bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01'
   OR bdate > GETDATE();

-- check data standardisation and consistency in gen
-- Expectation: a short list of consistent values
SELECT DISTINCT gen
FROM silver.erp_cust_az12;

