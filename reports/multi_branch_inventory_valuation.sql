/*
PROJECT: Multi-Branch Inventory Valuation Report
OBJECTIVE: Aggregate stock quantities across multiple company branches, providing a consolidated view of total inventory value and last movement date.
TECHNOLOGIES: SQL Server, CTEs, Conditional Aggregations, Subqueries.
AUTHOR: Cristian
*/

WITH BranchStockSummary AS (
    SELECT
        P.Code_Sort,
        P.Name AS Product_Name,
        P.Code AS Product_Code,
        -- Conditional aggregation to pivot branch quantities into columns
        SUM(CASE WHEN B.ID = @Branch1 THEN S.Current_Stock ELSE 0 END) AS Branch1_Qty,
        SUM(CASE WHEN B.ID = @Branch2 THEN S.Current_Stock ELSE 0 END) AS Branch2_Qty,
        SUM(CASE WHEN B.ID = @Branch3 THEN S.Current_Stock ELSE 0 END) AS Branch3_Qty,
        SUM(CASE WHEN B.ID = @Branch4 THEN S.Current_Stock ELSE 0 END) AS Branch4_Qty,
        SUM(CASE WHEN B.ID = @Branch5 THEN S.Current_Stock ELSE 0 END) AS Branch5_Qty,

        -- Dynamic branch labels using subqueries
        (SELECT CASE WHEN @Branch1 > 0 THEN CONCAT('Branch ', Code) ELSE '' END FROM Branches WHERE ID = @Branch1) AS Label_B1,
        (SELECT CASE WHEN @Branch2 > 0 THEN CONCAT('Branch ', Code) ELSE '' END FROM Branches WHERE ID = @Branch2) AS Label_B2,
        
        PP.Price AS Unit_Price,
        MAX(MPS.Movement_Date) AS Last_Movement
    FROM Products P
    LEFT JOIN Current_Stock S ON S.Product_ID = P.ID
    LEFT JOIN Branches B ON B.ID = S.Branch_ID
    LEFT JOIN Product_Prices PP ON PP.Product_ID = P.ID 
    LEFT JOIN Price_Tables PT ON PT.ID = PP.Price_Table_ID
    LEFT JOIN Movement_Products MPS ON MPS.Product_ID = P.ID
    WHERE P.Is_Active = '1'
      AND PT.Name = @Price_Table
      AND B.ID IN (@Branch1, @Branch2, @Branch3, @Branch4, @Branch5)
    GROUP BY 
        P.Code_Sort, P.Name, P.Code, PP.Price
)
SELECT 
    *,
    Unit_Price * Total_Stock AS Total_Stock_Value
FROM (
    SELECT
        Label_B1, Label_B2, -- Include labels
        Product_Code,
        Product_Name,
        Branch1_Qty,
        Branch2_Qty,
        Branch3_Qty,
        Branch4_Qty,
        Branch5_Qty,
        Unit_Price,
        (Branch1_Qty + Branch2_Qty + Branch3_Qty + Branch4_Qty + Branch5_Qty) AS Total_Stock,
        Last_Movement
    FROM BranchStockSummary
) FinalTable
ORDER BY Product_Code;
