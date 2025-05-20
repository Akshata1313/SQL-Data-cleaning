CREATE TABLE blinkit_data (
    item_fat_content VARCHAR2(20),
    item_identifier VARCHAR2(20),
    item_type VARCHAR2(50),
    outlet_establishment_year NUMBER(4),
    outlet_identifier VARCHAR2(20),
    outlet_location_type VARCHAR2(20),
    outlet_size VARCHAR2(20),
    outlet_type VARCHAR2(30),
    item_visibility NUMBER(10,4),
    item_weight NUMBER(10,4),
    total_sales NUMBER(10,2),
    rating NUMBER(3,1)
);

SELECT * FROM blinkit_data;
SELECT count(*) FROM blinkit_data;


-------------DATA CLEANING STEPS
-- 1.Standardize Item_fat_content column.
UPDATE blinkit_data
SET Item_Fat_Content = CASE
  WHEN LOWER(Item_Fat_Content) IN ('low fat', 'lf') THEN 'Low Fat'
  WHEN LOWER(Item_Fat_Content) IN ('reg') THEN 'Regular'
  ELSE Item_Fat_Content
END;

-- 2. HANDLE NULLS OR INCORRECT ZERO VALUES
UPDATE Blinkit_data
SET Item_Weight = NULL
WHERE TRIM(Item_Weight) IS NULL OR Item_Weight = '';

--Average Visibility for only non-zero records.
SELECT AVG(Item_Visibility) AS Avg_Visibility
FROM blinkit_data
WHERE Item_Visibility > 0;

-- Average to update all records where visibility is zero.
UPDATE Blinkit_Data
SET Item_Visibility = (
    SELECT AVG(Item_Visibility)
    FROM Blinkit_Data
    WHERE Item_Visibility > 0
)
WHERE Item_Visibility = 0;

SELECT COUNT(*)
FROM Blinkit_Data
WHERE Item_Visibility = 0;

-- 3.CLEAN CHECK
SELECT
  COUNT(*) AS Total_Records,
  COUNT(DISTINCT Item_Identifier) AS Unique_Items,
  COUNT(DISTINCT Outlet_Identifier) AS Unique_Outlets
FROM Blinkit_data;

-- BASIC LEVEL QUERIES
-- 1. List all records from the Blinkit_Data table.
SELECT COUNT(*) AS Total_records FROM blinkit_data;

-- 2. Show only the Item_Identifier and Total_Sales of all products.
SELECT item_identifier, Total_sales FROM blinkit_data;

-- 3. Find all unique Item_Type values.
SELECT DISTINCT(item_type) FROM blinkit_data;

-- 4. Count how many different Outlet_Type categories are there.
SELECT DISTINCT(outlet_type) as No_of_Outlet_types FROM blinkit_data;

-- 5. List all items where Item_Fat_Content is 'Low Fat'.
SELECT * FROM blinkit_data
WHERE item_fat_content = 'Low Fat';

-- 6. Find the total number of products with Rating greater than 4.
SELECT count(*) as High_rating_products FROM blinkit_data 
WHERE rating > 4; 

-- 7. Display all items sorted by Total_Sales descending.
SELECT * FROM blinkit_data 
ORDER BY Total_sales desc;

-- 8. Show the top 10 highest selling items based on Total_Sales.
SELECT * FROM blinkit_data ORDER BY total_sales DESC FETCH FIRST 10 ROWS ONLY;

--INTERMEDIATE LEVEL QUERIES

-- 9. Find the average Item_Visibility for each Item_Type.
SELECT item_type, AVG(Item_visibility) AS Average_visibility
FROM blinkit_data GROUP BY Item_type;

-- 10. Calculate total Total_Sales for each Outlet_Type.
SELECT outlet_type, sum(Total_sales) AS Total_Sales 
FROM blinkit_data GROUP BY outlet_type;

-- 11. List all outlets that were established before the year 2000.
SELECT outlet_identifier, outlet_establishment_year FROM blinkit_data
where outlet_establishment_year < 2000;

-- 12. Find the item with the highest Total_Sales in each Item_Type. (hint: use ROW_NUMBER or MAX)
SELECT item_type,item_identifier,max(total_sales) as Total_sales
FROM blinkit_data GROUP by item_type, item_identifier
ORDER BY item_type;

-- 13. List all items where Item_Weight is NULL or 0.
SELECT count(*) from blinkit_data WHERE item_weight = NULL;
SELECT item_weight FROM blinkit_data;

-- 14. Show how many items exist in each Outlet_Location_Type along with their total sales.
SELECT outlet_location_type, COUNT(*) AS Item_count, SUM(total_sales) AS Total_Sales
FROM blinkit_data
GROUP BY outlet_location_type;

--15. Find all products where the Item_Fat_Content is not 'Low Fat' or 'Regular'.
SELECT * FROM blinkit_data WHERE item_fat_content NOT IN('Low fat','Regular');

--ADVANCED LEVEL QUERIES
--.top 3 highest selling items per Outlet_Identifier using a window function.
SELECT * FROM (
    SELECT Outlet_Identifier, Item_Identifier, Total_Sales,
           RANK() OVER (PARTITION BY Outlet_Identifier ORDER BY Total_Sales DESC) AS Sales_Rank
    FROM blinkit_data
) WHERE Sales_Rank <= 3;

-- Classify the items based on item_visibility.

SELECT Item_Identifier, Item_Visibility,
CASE
    WHEN Item_Visibility > 0.2 THEN 'High Visibility'
    WHEN Item_Visibility BETWEEN 0.1 AND 0.2 THEN 'Medium Visibility'
    ELSE 'Low Visibility'
END AS Visibility_Level
FROM blinkit_data;

--. Find the percentage contribution of each Item_Type to the overall Total_Sales.
SELECT Item_Type,
       SUM(Total_Sales) AS Sales_By_Type,
       (SUM(Total_Sales) / (SELECT SUM(Total_Sales) FROM Blinkit_Data)) * 100 AS Percentage_Contribution
FROM Blinkit_Data
GROUP BY Item_Type;

--. Create a CTE (Common Table Expression) to find outlets where average sales are above the overall average sales.
WITH Outlet_Avg AS (
    SELECT Outlet_Identifier, AVG(Total_Sales) AS Avg_Sales
    FROM Blinkit_Data
    GROUP BY Outlet_Identifier
)
SELECT *
FROM Outlet_Avg
WHERE Avg_Sales > (SELECT AVG(Total_Sales) FROM Blinkit_Data);

--. Write a query to find which Outlet_Location_Type has the maximum number of Large outlets.
SELECT Outlet_Location_Type, COUNT(*) AS Large_Outlet_Count
FROM Blinkit_Data
WHERE Outlet_Size = 'High'
GROUP BY Outlet_Location_Type
ORDER BY Large_Outlet_Count DESC FETCH FIRST 1 ROW ONLY;

--. Use a CASE statement to label each product as "Premium" if Rating >=4.5, "Good" if between 3 and 4.5, otherwise "Average".
SELECT item_identifier, Item_Type, Rating,
CASE
  WHEN Rating >= 4.5 THEN 'Premium'
  WHEN Rating between 3 and 4.5 THEN 'Good'
  ELSE 'Average'
END AS Product_Label
FROM blinkit_data;

--. Create a query to predict potential stock-out items Products having Rating > 4.5 and Item_Visibility < 0.05
SELECT *
FROM Blinkit_Data
WHERE Rating > 4.5 AND Item_Visibility < 0.05;

-- Rank all Outlet_Identifiers based on their total sales (highest to lowest) using RANK() function.
SELECT outlet_identifier, SUM(Total_sales) AS Total_Sales,
RANK() OVER(ORDER BY Sum(total_sales)DESC) AS Sales_Rank
FROM blinkit_data
GROUP BY outlet_identifier; 










