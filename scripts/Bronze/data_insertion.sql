CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT 'loading Bronze Layer';
        -- CRM
        SET @start_time = GETDATE();
        PRINT 'truncating table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;
        PRINT 'inserting data into bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM 'G:\SQL course\Data Warehouse Project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,            -- skip the header row
            FIELDTERMINATOR = ',',
            TABLOCK                  -- lock the table for the load
        );
        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'; 

        -- crm_prod_info
        SET @start_time = GETDATE();
        PRINT 'truncating table: bronze.crm_prod_info';
        TRUNCATE TABLE bronze.crm_prod_info;
        PRINT 'inserting data into bronze.crm_prod_info';
        BULK INSERT bronze.crm_prod_info
        FROM 'G:\SQL course\Data Warehouse Project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,            -- skip the header row
            FIELDTERMINATOR = ',',
            TABLOCK                  -- lock the table for the load
        );
        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -- crm_sales_details
        SET @start_time = GETDATE();
        PRINT 'truncating table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;
        PRINT 'inserting data into bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'G:\SQL course\Data Warehouse Project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,            -- skip the header row
            FIELDTERMINATOR = ',',
            TABLOCK                  -- lock the table for the load
        );
        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -- erp_cust_az12
        SET @start_time = GETDATE();
        PRINT 'truncating table: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;
        PRINT 'inserting data into bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM 'G:\SQL course\Data Warehouse Project\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,            -- skip the header row
            FIELDTERMINATOR = ',',
            TABLOCK                  -- lock the table for the load
        );
        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -- erp_loc_a101
        SET @start_time = GETDATE();
        PRINT 'truncating table: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;
        PRINT 'inserting data into bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM 'G:\SQL course\Data Warehouse Project\datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,            -- skip the header row
            FIELDTERMINATOR = ',',
            TABLOCK                  -- lock the table for the load
        );
        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        -- erp_px_cat_g1v2
        SET @start_time = GETDATE();
        PRINT 'truncating table: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        PRINT 'inserting data into bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'G:\SQL course\Data Warehouse Project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,            -- skip the header row
            FIELDTERMINATOR = ',',
            TABLOCK                  -- lock the table for the load
        );
        SET @end_time = GETDATE();
        PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        SET @batch_end_time = GETDATE()
        PRINT 'Loading Bronze layer is completed Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';

    END TRY
    BEGIN CATCH
        PRINT 'Error Message' + ERROR_MESSAGE();
        PRINT 'Error Number' + CAST(ERROR_NUMBER() AS NVARCHAR)
    END CATCH

END

 EXEC bronze.load_bronze
