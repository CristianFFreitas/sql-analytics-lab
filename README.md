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

* #### 💰 Profit Margin Analysis by Manufacturer
**The Problem:** The management needed to identify which manufacturers provided the best returns, comparing the actual sales price against three different cost benchmarks: Purchase Cost, Average Moving Cost, and a Target Price Table.

**The Solution:** Developed an advanced financial query using **Nested Subqueries** and **Outer Apply** to perform real-time currency conversion and cost comparisons. The report handles sales returns automatically by inverting signs based on operation types.

**Technical Highlights:**
* **Multiple Margin Perspectives:** Calculated profitability using three distinct cost bases for deeper financial insight.
* **Currency Normalization:** Used `OUTER APPLY` to fetch the most recent exchange rates for non-local currency products.
* **Complex Aggregation:** Implemented sign-switching logic within `SUM` functions to ensure returns are correctly deducted from totals.

* ---
### 🔗 Web3 & Blockchain Analytics
I am currently exploring the Solana ecosystem. You can track my live on-chain dashboards here:
* [My Dune Analytics Profile]((https://dune.com/cristianfraga))
