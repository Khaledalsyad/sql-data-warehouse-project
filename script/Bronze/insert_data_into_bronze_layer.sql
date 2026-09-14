EXEC Bronze.loaded_Bronze

CREATE OR ALTER PROCEDURE Bronze.loaded_Bronze
AS 
BEGIN;
	DECLARE @start_date as DATETIME, @end_date AS DATETIME 
	BEGIN TRY 
		PRINT '========================================='
		PRINT 'START LOEADED THE BRONZE LAYER'
		PRINT '========================================='

		PRINT '-----------------------------------------'
		PRINT 'LOADE CRM TABLES'
		PRINT '-----------------------------------------'

		PRINT 'DATE OF LOADED'
		SET @start_date = GETDATE()
		PRINT 'TRUNCATE TABEL crm_cust_info'
		TRUNCATE TABLE Bronze.crm_cust_info
		PRINT 'INSERT TABLE crm_cust_info'
		BULK INSERT Bronze.crm_cust_info
		FROM 'D:\SQL\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @start_date = GETDATE()
		PRINT 'TIME OF LOADED IS: ' + CAST(DATEDIFF(second, @start_date, @end_date) AS VARCHAR) + 'seconds'

		SET @start_date = GETDATE()
		PRINT 'TRUNCATE TABEL crm_prd_info'
		TRUNCATE TABLE Bronze.crm_prd_info
		PRINT 'INSERT TABLE crm_prd_info'
		BULK INSERT Bronze.crm_prd_info
		FROM 'D:\SQL\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_date = GETDATE()
		PRINT 'TIME OF LOADED IS: ' + CAST(DATEDIFF(second, @start_date, @end_date) AS VARCHAR) + 'seconds'

		SET @start_date = GETDATE()
		PRINT 'TRUNCATE TABLE crm_sales_details'
		TRUNCATE TABLE Bronze.crm_sales_details
		PRINT 'INSERT TABLE crm_sales_details'
		BULK INSERT Bronze.crm_sales_details
		FROM 'D:\SQL\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_date = GETDATE()
		PRINT 'TIME OF LOADED IS: ' + CAST(DATEDIFF(second, @start_date, @end_date) AS VARCHAR) + 'seconds'

		PRINT '-----------------------------------------'
		PRINT 'LOADE ERP TABLES'
		PRINT '-----------------------------------------'

		SET @start_date = GETDATE()
		PRINT 'TRUNCATE TABLE erp_cust_az12'
		TRUNCATE TABLE Bronze.erp_cust_az12
		PRINT 'INSERT TABLE erp_cust_az12'
		BULK INSERT Bronze.erp_cust_az12
		FROM 'D:\SQL\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_date = GETDATE()
		PRINT 'TIME OF LOADED IS: ' + CAST(DATEDIFF(second, @start_date, @end_date) AS VARCHAR) + 'seconds'

		SET @start_date = GETDATE()
		PRINT 'TRUNCATE TABLE erp_loc_a101'
		TRUNCATE TABLE Bronze.erp_loc_a101
		PRINT 'INSERT TABLE erp_loc_a101'
		BULK INSERT Bronze.erp_loc_a101
		FROM 'D:\SQL\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_date = GETDATE()
		PRINT 'TIME OF LOADED IS: ' + CAST(DATEDIFF(second, @start_date, @end_date) AS VARCHAR) + 'seconds'

		SET @start_date = GETDATE()
		PRINT 'TRUNCATE TABLE erp_px_cat_g1v2'
		TRUNCATE TABLE Bronze.erp_px_cat_g1v2
		PRINT 'INSERT TABLE erp_px_cat_g1v2'
		BULK INSERT Bronze.erp_px_cat_g1v2
		FROM 'D:\SQL\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_date = GETDATE()
		PRINT 'TIME OF LOADED IS: ' + CAST(DATEDIFF(second, @start_date, @end_date) AS VARCHAR) + 'seconds'

	END TRY
	BEGIN CATCH 
		PRINT '============================================='
		PRINT 'ERROR MASSEGE'+ ERROR_MESSAGE();
		PRINT 'ERROR NUMPER' + CAST(ERROR_NUMBER() AS VARCHAR);
		PRINT 'ERROR STATE' +  CAST(ERROR_STATE() AS VARCHAR)
	END CATCH

END
