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
