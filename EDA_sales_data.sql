-- Basic Summary Stats
SELECT COUNT(*) AS "Total_Sales_Quantity", SUM("Qty") AS "Total_Quantity_Sold", AVG("Total") AS "Average_Sale_Value", SUM("Total") AS "Total Sales $" FROM sales;


--Sales Over Time
SELECT "Date", SUM("Total") AS "Daily_Sales" FROM sales GROUP BY "Date" ORDER BY "Date";

--Product Performance
SELECT "Description", 
       SUM("Qty") AS "Total_Quantity_Sold",
       AVG("Retail") AS "Average_Retail_Price",
       SUM("Qty") * AVG("Retail") AS "Estimated_Total_Revenue",
FROM sales 
GROUP BY "Description" 
ORDER BY "Estimated_Total_Revenue" DESC;



--Customer Analysis
SELECT "Customer", COUNT(*) AS "Number_of_Purchases", SUM("Total") AS "Total_Spent"
FROM sales GROUP BY "Customer" ORDER BY "Total_Spent" DESC;

SELECT "Customer", COUNT(*) AS "Number_of_Purchases", SUM("Total") AS "Total_Spent"
FROM sales GROUP BY "Customer" ORDER BY "Number_of_Purchases" DESC;


--Sales By Location
SELECT "Location", SUM("Total") AS "Total_Sales" 
FROM sales GROUP BY "Location";

--Discount Impact Analysis (compare average sale after discount to average sale)
SELECT AVG("Discount") AS "Average_Discount", AVG("Total") AS "Average_Sale_After_Discount" 
FROM sales WHERE "Discount" > 0;


--Total Tax by location
SELECT SUM("Total" - "Subtotal") AS "Total_Tax_Collected", "Location"
FROM sales
WHERE "Total" > 0
GROUP BY "Location";

--Average Transaction value by customer
SELECT "Customer", AVG("Total") AS "Average_Transaction_Value" 
FROM sales GROUP BY "Customer" ORDER BY "Average_Transaction_Value" DESC;

--Analysis of Returns
SELECT * FROM sales WHERE "Total" < 0 ORDER BY "Total" ASC;









-- Sales Trends Over Time (Monthly)
SELECT DATE_TRUNC('month', "Date") AS "Month", SUM("Total") AS "Monthly_Sales"
FROM sales
GROUP BY "Month"
ORDER BY "Month";


-- Sales Performance by Day of the Week
SELECT EXTRACT(DOW FROM "Date") AS "Day_of_Week", SUM("Total") AS "Sales"
FROM sales
GROUP BY "Day_of_Week"
ORDER BY "Day_of_Week";

-- Customer Loyalty Analysis
SELECT "Customer", COUNT(*) AS "Visits", SUM("Total") AS "Total_Spent"
FROM sales
GROUP BY "Customer"
HAVING COUNT(*) > 1
ORDER BY "Visits" DESC;

-- Geographic Analysis (Assuming customer location data is available)
-- Replace 'Location' with the actual field name for location
SELECT "Location", SUM("Total") AS "Sales_By_Location"
FROM sales
GROUP BY "Location";


-- Seasonal Analysis
SELECT DATE_TRUNC('quarter', "Date") AS "Season", SUM("Total") AS "Seasonal_Sales"
FROM sales
GROUP BY "Season"
ORDER BY "Season";

-- Average Transaction Size
SELECT DATE_TRUNC('month', "Date") AS "Month", AVG("Total") AS "Avg_Transaction_Size"
FROM sales
GROUP BY "Month"
ORDER BY "Month";

-- Refund and Return Analysis
SELECT "Description", COUNT(*) AS "Return_Count"
FROM sales
WHERE "Total" < 0
GROUP BY "Description"
ORDER BY "Return_Count" DESC;


--Item Category Breakdown
SELECT COUNT(*) AS "Total Items", "Category" FROM sales
GROUP BY "Category" ORDER BY "Total Items";

SELECT "Description", SUM("Total") AS "Total Revenue", "Category", "Location"
FROM sales
WHERE "Category" LIKE 'Ski'
GROUP BY "Description", "Category", "Location"
ORDER BY "Total Revenue" DESC;



