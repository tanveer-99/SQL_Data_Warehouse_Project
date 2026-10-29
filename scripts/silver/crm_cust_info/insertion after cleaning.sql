-- this query inserts the data from bronze.crm_cust_info to silver.crm_cust_info after dealing with these:
-- 1. duplicate records
--    keeps only the latest record per cst_id (ROW_NUMBER + flag_last = 1)

-- 2. missing primary keys
--    removes rows where cst_id is NULL

-- 3. unwanted spaces
--    trims leading and trailing spaces from first and last names

-- 4. inconsistent codes and abbreviations
--    converts S/M to Single/Married and F/M to Female/Male

-- 5. inconsistent letter case
--    UPPER() makes 'f' and 'F' behave the same before mapping

-- 6. missing or unknown categorical values
--    NULLs, blanks and unexpected codes in gender and marital status become 'n/a'


TRUNCATE TABLE silver.crm_cust_info;
INSERT INTO silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date
)
SELECT 
	cst_id,
	cst_key,
	TRIM(cst_firstname) AS cst_firstname,
	TRIM(cst_lastname) AS cst_lastname,
	CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
		WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
		ELSE 'n/a'
	END AS cst_marital_status,
	CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
		WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
		ELSE 'n/a'
	END AS cst_gndr,
	cst_create_date
FROM 
( 
SELECT 
*,
ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
FROM bronze.crm_cust_info
WHERE cst_id IS NOT NULL 
) AS t
WHERE flag_last = 1


