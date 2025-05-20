-- EDA Script for Blinkit_Data

-- 1. Total number of rows
SELECT COUNT(*) AS Total_Records FROM Blinkit_Data;

-- 2. How many unique Item Identifiers
SELECT COUNT(DISTINCT Item_Identifier) AS Unique_Items FROM Blinkit_Data;

-- 3. How many unique Outlet Identifiers
SELECT COUNT(DISTINCT Outlet_Identifier) AS Unique_Outlets FROM Blinkit_Data;

-- 4. Minimum, Maximum, and Average Total Sales
SELECT 
    MIN(Total_Sales) AS Min_Sales,
    MAX(Total_Sales) AS Max_Sales,
    ROUND(AVG(Total_Sales), 2) AS Avg_Sales
FROM Blinkit_Data;

-- 5. Average, Min, and Max Item Weight
SELECT 
    MIN(Item_Weight) AS Min_Weight,
    MAX(Item_Weight) AS Max_Weight,
    ROUND(AVG(Item_Weight), 2) AS Avg_Weight
FROM Blinkit_Data;

-- 6. How many items have Rating greater than 4
SELECT COUNT(*) AS Products_Rating_Above_4
FROM Blinkit_Data
WHERE Rating > 4;

-- 7. Number of items for each Item_Fat_Content
SELECT Item_Fat_Content, COUNT(*) AS Item_Count
FROM Blinkit_Data
GROUP BY Item_Fat_Content
ORDER BY Item_Count DESC;

-- 8. Number of items by Item Type
SELECT Item_Type, COUNT(*) AS Item_Count
FROM Blinkit_Data
GROUP BY Item_Type
ORDER BY Item_Count DESC;

-- 9. Average Sales per Item Type
SELECT Item_Type, ROUND(AVG(Total_Sales),2) AS Avg_Sales
FROM Blinkit_Data
GROUP BY Item_Type
ORDER BY Avg_Sales DESC;

-- 10. Top 5 highest selling products (by Total Sales)
SELECT Item_Identifier, Item_Type, Total_Sales
FROM Blinkit_Data
ORDER BY Total_Sales DESC
FETCH FIRST 5 ROWS ONLY;

-- 11. Outlet-wise total sales
SELECT Outlet_Identifier, ROUND(SUM(Total_Sales),2) AS Total_Sales
FROM Blinkit_Data
GROUP BY Outlet_Identifier
ORDER BY Total_Sales DESC;

-- 12. Outlet Size vs Average Sales
SELECT Outlet_Size, ROUND(AVG(Total_Sales),2) AS Avg_Sales
FROM Blinkit_Data
GROUP BY Outlet_Size
ORDER BY Avg_Sales DESC;

-- 13. Outlet Type vs Average Rating
SELECT Outlet_Type, ROUND(AVG(Rating),2) AS Avg_Rating
FROM Blinkit_Data
GROUP BY Outlet_Type
ORDER BY Avg_Rating DESC;

-- 14. Number of items with Zero Visibility (possible data issue)
SELECT COUNT(*) AS Zero_Visibility_Items
FROM Blinkit_Data
WHERE Item_Visibility = 0;

-- 15. Average Item Visibility
SELECT ROUND(AVG(Item_Visibility),4) AS Avg_Visibility
FROM Blinkit_Data;

-- 16. Item Types with highest average visibility
SELECT Item_Type, ROUND(AVG(Item_Visibility),4) AS Avg_Visibility
FROM Blinkit_Data
GROUP BY Item_Type
ORDER BY Avg_Visibility DESC;

-- 17. Sales performance by Outlet Establishment Year
SELECT Outlet_Establishment_Year, ROUND(AVG(Total_Sales),2) AS Avg_Sales
FROM Blinkit_Data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year;

-- 18. Rating distribution (how many products have 1,2,3,4,5 star)
SELECT Rating, COUNT(*) AS Rating_Count
FROM Blinkit_Data
GROUP BY Rating
ORDER BY Rating;

-- 19. Number of products by Outlet Location Type
SELECT Outlet_Location_Type, COUNT(*) AS Count_By_Location
FROM Blinkit_Data
GROUP BY Outlet_Location_Type
ORDER BY Count_By_Location DESC;

-- 20. Total sales contribution by Fat Content type
SELECT Item_Fat_Content, ROUND(SUM(Total_Sales),2) AS Total_Sales
FROM Blinkit_Data
GROUP BY Item_Fat_Content
ORDER BY Total_Sales DESC;

-- 21. Top 5 items by highest Rating
SELECT Item_Identifier, Item_Type, Rating
FROM Blinkit_Data
ORDER BY Rating DESC, Total_Sales DESC
FETCH FIRST 5 ROWS ONLY;

-- 22. Average Total Sales for items with high visibility (> 0.1)
SELECT ROUND(AVG(Total_Sales),2) AS Avg_Sales_High_Visibility
FROM Blinkit_Data
WHERE Item_Visibility > 0.1;

-- 23. Identify Items with Extremely High Item Weight (> 20 kg)
SELECT *
FROM Blinkit_Data
WHERE Item_Weight > 20
ORDER BY Item_Weight DESC;

-- End of EDA
