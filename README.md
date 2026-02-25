# sql-analytics-lab
A repository for SQL studies and solutions, ranging from management reports for ERPs to on-chain data analysis (Web3). Focused on query optimization and Business Intelligence

## Projects Showcase

#### 📈 Dynamic Sales Report (Pivot Table)
**The Problem:** The client required a comparative annual view of month-over-month sales, but the database stores data per transaction (rows).

**The Solution:** Implemented the `PIVOT` function to rotate temporal data into columns, facilitating executive-level data visualization.

**Technical Highlights:**
* **Grid Management:** Used `CASE WHEN` and `CONCAT` to display product variations (Color and Size).
* **Net Volume Calculation:** Implemented logic to subtract returns from total sales volume within the aggregation.
* **Efficiency:** Utilized Common Table Expressions (CTEs) to filter and group data before applying the Pivot transformation.

#### 📦 Multi-Branch Inventory Valuation
**The Problem:** The business needed to compare stock levels across several physical locations (branches) and calculate the total financial exposure of the inventory.

**The Solution:** Developed a complex report using **Conditional Aggregations** to manually pivot branch data. The query also calculates total stock value in real-time by joining current stock levels with price tables.

**Technical Highlights:**
* **Cross-Tabulation:** Used `SUM(CASE WHEN...)` logic to distribute stock quantities into distinct branch columns.
* **Correlated Subqueries:** Implemented dynamic labeling for columns based on branch parameters.
* **Financial Calculation:** Nested logic to compute the total inventory value (`Quantity * Price`) across all selected locations.
