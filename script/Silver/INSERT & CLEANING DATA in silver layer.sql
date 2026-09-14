CREATE OR ALTER PROCEDURE Silver.loaded_silver
AS
BEGIN
	DECLARE @start_date AS DATETIME, @end_date AS DATETIME
	BEGIN TRY
		PRINT '================================================'
		PRINT '--------LOADE THE SILVER LAYER'
		PRINT '================================================'
		PRINT '#'
		PRINT '#'
		PRINT '#'
		PRINT '#'
		PRINT '#'
		
		PRINT '================================================'
		PRINT '--------START LOADED THE SILVER CRM '
		PRINT '================================================'

		print '------------------------------'
		PRINT 'Start The Truncate Table crm_cust_info' 
		print '------------------------------'
		SET @start_date  = GETDATE()
		TRUNCATE TABLE Silver.crm_cust_info
		PRINT 'Start Insert Table crm_cust_info'
		INSERT INTO Silver.crm_cust_info(cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date)
		SELECT 
		cst_id,
		cst_key,
		TRIM(cst_firstname) AS cst_firstname,
		TRIM(cst_lastname) AS cst_lastname,
		CASE 
			WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
			WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Maride'
			ELSE 'a/n'
		END AS cst_marital_status,
		CASE
			WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Fimale'
			WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
			ELSE 'a/n'
		END AS cst_gndr,
		cst_create_date
		FROM(
			SELECT *,
			ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date) Filter_id
			FROM Bronze.crm_cust_info
			WHERE cst_id IS NOT NULL
		)t
		WHERE Filter_id = 1
		SET @end_date = GETDATE()
		PRINT 'TABLE TAKEIT TIME IS' + CAST(DATEDIFF(second, @start_date, @end_date) AS VARCHAR)

		print '=========================================='
		PRINT 'Truncate Silver Table Silver.crm_prd_info'
		print '=========================================='
		SET @start_date = GETDATE()
		TRUNCATE TABLE  Silver.crm_prd_info
		PRINT 'Insert Silver Table Silver.crm_prd_info'
		INSERT INTO Silver.crm_prd_info( prd_id, prd_key, cst_id, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt)
		SELECT 
		prd_id,
		SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
		REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cst_id,
		prd_nm,
		ISNULL(prd_cost, 0) AS prd_cost,
		CASE UPPER(TRIM(prd_line))
			WHEN 'M' THEN 'Mountain'
			WHEN 'R' THEN 'Road'
			WHEN 'S' THEN 'Other Sales'
			WHEN 'T' THEN 'Touring'
			ELSE 'a/n'
		END AS prd_line,
		CAST(prd_start_dt AS DATE) prd_start_dt,
		CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) AS DATE) AS prd_end_dt
		FROM Bronze.crm_prd_info
		SET @end_date = GETDATE()
		PRINT 'TABLE TAKEIT TIME IS' + CAST(DATEDIFF(second, @start_date, @end_date) AS VARCHAR)

		print '================================================'
		PRINT 'Truncate Silver Table Silver.crm_sales_details'
		print '================================================'
		SET @start_date = GETDATE()
		TRUNCATE TABLE Silver.crm_sales_details
		print 'Insert Silver Table Silver.crm_sales_details'
		INSERT INTO Silver.crm_sales_details(sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt,
		sls_sales, sls_quantity, sls_price)
		SELECT 
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		CASE
			WHEN sls_order_dt <=0 OR LEN(sls_order_dt) != 8 THEN NULL
			ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
		END sls_order_dt,
		CASE
			WHEN sls_ship_dt <=0 OR LEN(sls_ship_dt) != 8 THEN NULL
			ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
		END sls_ship_dt,
		CASE
			WHEN sls_due_dt <=0 OR LEN(sls_due_dt) != 8 THEN NULL
			ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
		END sls_due_dt,
		CASE
			WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
				THEN sls_quantity * ABS(sls_price)
			ELSE sls_sales
		END AS sls_sales,
		sls_quantity,
		CASE
			WHEN sls_price IS NULL OR sls_sales <= 0 OR sls_price != sls_quantity / sls_sales
				THEN  sls_sales / NULLIF(sls_quantity, 0)
			ELSE sls_price
		END AS sls_price
		FROM Bronze.crm_sales_details
		SET @end_date = GETDATE()
		PRINT 'TABLE TAKEIT TIME IS' + CAST(DATEDIFF(second, @start_date, @end_date) AS VARCHAR)

		PRINT '================================================'
		PRINT '--------START LOADED THE SILVER CRM '
		PRINT '================================================'
		PRINT '#'
		PRINT '#'
		PRINT '#'
		SET @start_date = GETDATE()
		print '================================================'
		PRINT 'Truncate Silver Table Silver.erp_cust_az12'
		print '================================================'
		TRUNCATE TABLE Silver.erp_cust_az12
		print 'Insert Silver Table Silver.erp_cust_az12'
		INSERT INTO Silver.erp_cust_az12(cid, gen, bdate)
		SELECT  
		CASE
		  WHEN cid LIKE 'NASA%' THEN SUBSTRING(cid, 4, LEN(cid)) 
		  ELSE cid
		END cust_id,
		CASE UPPER(TRIM(gen))
			WHEN 'F' THEN 'Female'
			WHEN 'M' THEN 'Male'
			WHEN 'Female' THEN 'Female'
			WHEN 'Male' THEN 'Male'
			ELSE 'a/n'
		END Gender,
		CASE
			WHEN bdate > GETDATE() THEN NULL
			ELSE bdate
		END bdate
		FROM Bronze.erp_cust_az12
		SET @end_date = GETDATE()
		PRINT 'TABLE TAKEIT TIME IS' + CAST(DATEDIFF(second, @start_date, @end_date) AS VARCHAR)

		SET @start_date = GETDATE()
		print '================================================'
		PRINT 'Truncate Silver Table Silver.erp_loc_a101'
		print '================================================'
		TRUNCATE TABLE Silver.erp_loc_a101
		print 'InsertSilver Table Silver.erp_loc_a101'
		INSERT INTO Silver.erp_loc_a101(cid, cntry)
		SELECT 
		REPLACE(cid, '-', '') cid,
		CASE
			WHEN TRIM(cntry) = 'DE' THEN 'Germany'
			WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
			WHEN TRIM(cntry) IS NULL OR TRIM(cntry) = '' THEN NULL
			ELSE TRIM(cntry)
		END AS cntry
		FROM Bronze.erp_loc_a101
		SET @end_date = GETDATE()
		PRINT 'TABLE TAKEIT TIME IS' + CAST(DATEDIFF(second, @start_date, @end_date) AS VARCHAR)

		SET @start_date = GETDATE()
		print '================================================'
		PRINT 'Truncate Silver TableSilver.erp_px_cat_g1v2'
		print '================================================'
		TRUNCATE TABLE Silver.erp_px_cat_g1v2
		print 'Insert Silver Table Silver.erp_px_cat_g1v2'
		INSERT INTO Silver.erp_px_cat_g1v2(
			id,
			cat,
			subcat,
			maintenance
		)
		SELECT *
		FROM Bronze.erp_px_cat_g1v2
		SET @end_date = GETDATE()
		PRINT 'TABLE TAKEIT TIME IS' +CAST(DATEDIFF(second, @start_date, @end_date) AS VARCHAR)
	END TRY
		BEGIN CATCH
			PRINT 'ERROR MESSAGE IS' + '' + ERROR_MESSAGE();
			PRINT 'NUMBR OF MESSAGE' + '' +CAST(ERROR_NUMBER() AS VARCHAR);
			PRINT 'STATE OF MESSAGE' + '' +CAST(ERROR_STATE () AS VARCHAR) 
		END CATCH
END





