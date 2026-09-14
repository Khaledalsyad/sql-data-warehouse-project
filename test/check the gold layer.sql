--=====================================
-- Check The Duplicte OF dim_customer
--=====================================
SELECT Customer_id ,
COUNT(*)
FROM Gold.dim_customer
GROUP BY Customer_id
HAVING COUNT(*) > 1

--=====================================
-- Check The Duplicte OF dim_product
--=====================================
SELECT 
Product_id,
COUNT(*)
FROM Gold.dim_product
GROUP BY Product_id 
HAVING COUNT(*) > 1


--=====================================
-- Check Table Fact_sales
--=====================================
SELECT *
FROM Gold.fact_sales F
LEFT JOIN Gold.dim_customer C ON F.Customer_id = C.Customer_id
LEFT JOIN Gold.dim_product P ON F.Product_key = p.Product_num

