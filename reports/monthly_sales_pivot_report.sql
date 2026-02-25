/*
PROJECT: Monthly Sales Performance Report (Pivot Table)
OBJECTIVE: Analyze annual sales flow per product, categorized by class, family, and manufacturer, supporting grid-based products (color/size).
TECHNOLOGIES: SQL Server, CTEs, PIVOT, Subqueries, Complex Joins.
AUTHOR: Cristian
*/

WITH MovementData AS (
    SELECT 
        P.Code AS ProductCode,
        -- Logic to handle grid-based products (Color and Size)
        CASE 
            WHEN PSG.Color_Order IS NOT NULL AND PSG.Size_Order IS NOT NULL 
            THEN CONCAT(P.Name, ' - ', ISNULL(C.Name, ''), ' / ', ISNULL(T.Name, '')) 
            ELSE P.Name 
        END AS ProductName,
        CONCAT(CL.Code, ' - ', CL.Name) AS Category,
        P_Prices.Price AS SalesPrice,
        -- Quantity Logic: Deducting returns from total sold
        SUM(CASE 
                WHEN M.Operation_Type IN ('DEV', 'CVE', 'DVF') THEN -1.0 * MPS.Quantity
                ELSE MPS.Quantity 
            END) AS Quantity,
        MONTH(M.Effective_Date) AS SalesMonth
    FROM Movement M
    INNER JOIN Movement_Products MPS ON MPS.Movement_ID = M.ID
    INNER JOIN Products P ON MPS.Product_ID = P.ID
    INNER JOIN Categories CL ON P.Category_ID = CL.ID
    LEFT JOIN Products_Grid PSG ON MPS.Product_ID = PSG.Product_ID 
                                   AND MPS.Color_ID = PSG.Color_ID
                                   AND MPS.Size_ID = PSG.Size_ID
    LEFT JOIN Colors C ON PSG.Color_ID = C.ID
    LEFT JOIN Sizes T ON PSG.Size_ID = T.ID
    LEFT JOIN Product_Prices P_Prices ON P.ID = P_Prices.Product_ID
    WHERE M.Is_Deleted = 0
      AND M.Effective_Date BETWEEN @Start_Date AND @End_Date
    GROUP BY 
        P.Code, P.Name, CL.Code, CL.Name, C.Name, T.Name, 
        PSG.Color_ID, PSG.Size_ID, P_Prices.Price, MONTH(M.Effective_Date)
)

-- Rotating rows (months) into columns using PIVOT
SELECT 
    ProductCode,
    ProductName,
    Category,
    SalesPrice,
    ISNULL([1], 0) AS Jan, ISNULL([2], 0) AS Feb, ISNULL([3], 0) AS Mar,
    ISNULL([4], 0) AS Apr, ISNULL([5], 0) AS May, ISNULL([6], 0) AS Jun,
    ISNULL([7], 0) AS Jul, ISNULL([8], 0) AS Aug, ISNULL([9], 0) AS Sep,
    ISNULL([10], 0) AS Oct, ISNULL([11], 0) AS Nov, ISNULL([12], 0) AS Dec
FROM MovementData
PIVOT (
    SUM(Quantity)
    FOR SalesMonth IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
) AS PivotTable
ORDER BY ProductName;
