DECLARE @StartDate DATE;
DECLARE @EndDate DATE;


--====================================
-- CREATE DIM CUSTOMER
--====================================
IF OBJECT_ID('Gold.dim_customer', 'V') IS NOT NULL
	DROP VIEW Gold.dim_customer
Go
CREATE VIEW Gold.dim_customer AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY C.cst_id) AS Customer_key,
	C.cst_id  AS Customer_id,
	C.cst_firstname AS First_name,
	C.cst_lastname AS Last_name,
	C.cst_marital_status AS Marital_Status,
	C.cst_gndr AS Gander,
	L.cntry AS Country,
	C.cst_create_date AS Create_Date,
	p.bdate AS Parth_Date,
	C.dwh_create_date
FROM Silver.crm_cust_info C
LEFT JOIN Silver.erp_cust_az12  P ON C.cst_key = P.cid
LEFT JOIN Silver.erp_loc_a101 L ON C.cst_key = L.cid


--====================================
-- CREATE DIM PRODUCT
--====================================
IF OBJECT_ID('Gold.dim_product', 'V') IS NOT NULL
	DROP VIEW Gold.dim_product 
GO
CREATE VIEW Gold.dim_product AS
SELECT
	ROW_NUMBER() OVER(ORDER BY pr.prd_id) AS Product_key,
	pr.prd_id AS Product_id,
	pr.prd_key AS Product_num,
	pr.cst_id AS Category_id,
	cat.cat AS Category,
	cat.subcat AS Sub_Category,
	pr.prd_nm AS Product_name,
	pr.prd_cost AS Product_cost,
	pr.prd_line AS Product_line,
	cat.maintenance AS Maintenance,
	pr.prd_start_dt AS Start_date
FROM Silver.crm_prd_info AS pr
LEFT JOIN Silver.erp_px_cat_g1v2 AS cat ON pr.cst_id = cat.id
WHERE pr.prd_end_dt IS NULL -- out of historicale date


--=========================================
-- CREATE FACT SALES
--=========================================
IF OBJECT_ID('Gold.fact_sales', 'V') IS NOT NULL
	DROP VIEW Gold.fact_sales
GO
CREATE VIEW Gold.fact_sales AS
SELECT 
	CS.sls_ord_num AS Order_nmber,
	DP.Product_Num AS Product_key,
	DC.Customer_id AS Customer_id,
	CS.sls_order_dt AS Order_Date,
	CS.sls_ship_dt AS Ship_Date,
	CS.sls_due_dt AS Due_Date,
	CS.sls_sales AS Sales,
	CS.sls_quantity AS Quantity,
	CS.sls_price AS Price
FROM Silver.crm_sales_details CS
LEFT JOIN Gold.dim_customer DC ON CS.sls_cust_id = DC.Customer_id
LEFT JOIN Gold.dim_product DP ON CS.sls_prd_key = DP.Product_num



--==================================
--DDL DIM DATE
--==================================
IF OBJECT_ID('Gold.dim_date', 'N') IS NOT NULL
	DROP TABLE Gold.dim_date

CREATE TABLE Gold.dim_date
(
    Date_key INT PRIMARY KEY,
    Full_date DATE NOT NULL,

    Day_number INT,
    Day_name NVARCHAR(20),

    Month_number INT,
    Month_name NVARCHAR(20),

    Quarter_number INT,
    Year_number INT,

    Week_number INT,

    Is_weekend BIT
);


--==================================
--INSERT AND CLEANING DIMDATE
--==================================
DECLARE  @StartDate AS DATE
DECLARE @EndDate AS DATE
SELECT
    @StartDate = MIN(sls_order_dt),
    @EndDate = MAX(
        CASE
            WHEN sls_due_dt > sls_ship_dt
                THEN sls_due_dt
            ELSE sls_ship_dt
        END
    )
FROM Silver.crm_sales_details;


;WITH Date_CTE AS
(
    SELECT @StartDate AS Full_date

    UNION ALL

    SELECT DATEADD(DAY, 1, Full_date)
    FROM Date_CTE
    WHERE Full_date < @EndDate
)

INSERT INTO Gold.dim_date
(
    Date_key,
    Full_date,
    Day_number,
    Day_name,
    Month_number,
    Month_name,
    Quarter_number,
    Year_number,
    Week_number,
    Is_weekend
)
SELECT
    CONVERT(INT, FORMAT(Full_date, 'yyyyMMdd')) AS Date_key,

    Full_date,

    DAY(Full_date) AS Day_number,

    DATENAME(WEEKDAY, Full_date) AS Day_name,

    MONTH(Full_date) AS Month_number,

    DATENAME(MONTH, Full_date) AS Month_name,

    DATEPART(QUARTER, Full_date) AS Quarter_number,

    YEAR(Full_date) AS Year_number,

    DATEPART(WEEK, Full_date) AS Week_number,

    CASE
        WHEN DATENAME(WEEKDAY, Full_date) IN ('Saturday', 'Sunday')
            THEN 1
        ELSE 0
    END AS Is_weekend

FROM Date_CTE

OPTION (MAXRECURSION 0);