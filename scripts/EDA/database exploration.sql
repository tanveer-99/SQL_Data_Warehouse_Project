SELECT * FROM INFORMATION_SCHEMA.TABLES
-- tells all the tables we have in the database

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'
-- tells all the columns we have and also those from the dim_customers table
