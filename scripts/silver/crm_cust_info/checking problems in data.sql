-- quality Check
-- Check for duplicates or NULLs in Primary key
-- Expectation: No results

SELECT 
cst_id,
COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id 
HAVING COUNT(*) > 1 OR cst_id IS NULL  
-- from result we can see that primary key in bronze.crm_cust_info table has duplicates and nulls


-- check for unwanted spaces in string values
SELECT 
cst_firstname, cst_lastname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)
SELECT
cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)
SELECT 
cst_gndr
FROM bronze.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr)
SELECT 
cst_marital_status
FROM bronze.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status)
-- from result we can see that there are some unwanted spaces in the first name and last name, but not in the gender and marital status


-- data standardization and consistency
-- in this project, the aim is to not using any abbrevietions, instead meaningful terms should be used
SELECT DISTINCT cst_gndr, cst_marital_status
FROM bronze.crm_cust_info




--------------------------------

-- quality check: silver.crm_cust_info

-- check for duplicates or NULLs in the primary key
-- Expectation: no results
SELECT
    cst_id,
    COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;


-- check for unwanted spaces in string values
-- Expectation: no results
SELECT
    cst_firstname,
    cst_lastname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT
    cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

SELECT
    cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

SELECT
    cst_marital_status
FROM silver.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status);


-- data standardisation and consistency
-- in this project, the aim is to not use any abbreviations, instead meaningful terms should be used
-- Expectation: only Male / Female / n/a and Single / Married / n/a
SELECT DISTINCT
    cst_gndr,
    cst_marital_status
FROM silver.crm_cust_info;
