/*
PROJECT: Profit Margin & Profitability Analysis by Manufacturer
OBJECTIVE: Calculate net sales, total costs, and profit margins comparing different cost bases (Purchase Cost, Average Cost, and Target Table Price).
TECHNOLOGIES: SQL Server, Subqueries, Outer Apply, Conditional Logic (CASE WHEN).
AUTHOR: Cristian
*/

SELECT 
    ManufacturerCode, 
    ManufacturerName,
    TotalSales,
    (TotalSales - PurchaseCost) AS NetProfit,
    -- Margin calculation based on Sales Purchase Cost
    CASE 
        WHEN PurchaseCost = 0 THEN 100
        WHEN PurchaseCost > 0 THEN (TotalSales - PurchaseCost) / TotalSales * 100 
    END AS Margin_vs_PurchaseCost,
    PurchaseCost,
    -- Margin calculation based on Average Moving Cost
    CASE 
        WHEN AverageCost = 0 THEN 100
        WHEN AverageCost > 0 THEN (TotalSales - AverageCost) / TotalSales * 100 
    END AS Margin_vs_AverageCost,
    AverageCost,
    -- Comparison against a Target Price Table
    CASE 
        WHEN TargetTablePrice = 0 THEN 100
        WHEN TargetTablePrice > 0 THEN (TotalSales - TargetTablePrice) / TotalSales * 100 
    END AS Margin_vs_TargetTable,
    TargetTablePrice
FROM (
    SELECT 
        Fab.Code AS ManufacturerCode,
        Fab.Name AS ManufacturerName,
        -- Sum of Sales adjusting for Returns (DEV/CVE)
        SUM(MPS.Final_Price * (CASE MOV.OperationType WHEN 'DEV' THEN -1 WHEN 'CVE' THEN -1 ELSE 1 END)) AS TotalSales,
        SUM(MPS.Purchase_Cost * (CASE MOV.OperationType WHEN 'DEV' THEN -1 WHEN 'CVE' THEN -1 ELSE 1 END)) AS PurchaseCost,
        SUM(MPS.Average_Cost * (CASE MOV.OperationType WHEN 'DEV' THEN -1 WHEN 'CVE' THEN -1 ELSE 1 END)) AS AverageCost,
        -- Calculating Target Table Price with Currency Conversion
        SUM(MPS.Item_Quantity * ISNULL(Price.Value, 0) * ISNULL(Currency.Rate, 1) * (CASE MOV.OperationType WHEN 'DEV' THEN -1 WHEN 'CVE' THEN -1 ELSE 1 END)) AS TargetTablePrice
    FROM Movement MOV
    INNER JOIN Movement_Items MPS ON MOV.ID = MPS.Movement_ID
    LEFT JOIN Products P ON P.ID = MPS.Product_ID
    LEFT JOIN Manufacturers Fab ON Fab.ID = P.Manufacturer_ID 
    -- Applying the latest price from a specific price table
    OUTER APPLY (
        SELECT TOP 1 PSP.Price AS Value 
        FROM Product_Prices PSP 
        WHERE PSP.Product_ID = MPS.Product_ID 
        AND PSP.Price_Table_ID = (SELECT ID FROM Price_Tables WHERE Name = @Cost_Table)
    ) Price
    -- Applying the latest currency exchange rate
    OUTER APPLY (
        SELECT TOP 1 C.Rate 
        FROM Exchange_Rates C 
        WHERE C.Currency_ID = P.Currency_ID AND P.Currency_ID <> 1 
        ORDER BY C.Date DESC
    ) Currency
    WHERE MOV.Is_Deleted = 0 
      AND MOV.OperationType IN ('VND', 'VEF', 'VPC', 'DEV', 'FPV', 'CVE')
      AND MOV.Branch_ID = @Branch
      AND M.Effective_Date BETWEEN @Start_Date AND @End_Date
    GROUP BY 
        Fab.Code, Fab.Name
) AS ProfitData
ORDER BY ManufacturerName;
