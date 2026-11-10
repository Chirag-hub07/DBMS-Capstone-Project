## 💼 Financial Portfolio Management System
 
### A Database Management System (DBMS) Project Using MySQL
 
**Developed by Chirag Virdi**
 
---
 
## 📌 Project Overview
 
The **Financial Portfolio Management System** is a MySQL-based database project designed to manage clients, portfolios, assets, investments, daily asset prices, and buy/sell transactions.
 
The project demonstrates how relational database concepts and advanced SQL techniques can be used to track investment performance, analyze asset allocation, rebalance portfolios, and generate financial reports.
 
Holdings, average cost, market value, and unrealized gain/loss are not stored manually. They are calculated directly from the transaction records, so the data is always consistent and up to date.
 
## 🎯 Project Objectives
 
- Design a structured relational database for financial portfolio management.
- Manage clients, portfolios, assets, investments, prices, and transactions.
- Implement primary keys, foreign keys, and integrity constraints.
- Track investment performance (quantity, average cost, market value, gain/loss).
- Analyze asset allocation and identify holdings that need rebalancing.
- Optimize queries using composite and covering indexes.
- Study the effect of index maintenance on bulk loading of price data.
- Create views, including a client-specific view for access control.
- Analyze returns using SQL window functions.
- Examine query execution plans using `EXPLAIN`.
## ✨ Key Features
 
| Feature | Description |
|---|---|
| Client Management | Stores client details, risk profile, and database login name |
| Portfolio Management | Supports multiple portfolios per client with a rebalancing threshold |
| Asset Management | Organizes assets by asset class (Equity, Bond, Commodity, etc.) |
| Price History | Stores daily closing prices of every asset (weak entity) |
| Investment Planning | Stores the target allocation of each asset in a portfolio |
| Transaction Tracking | Records every BUY and SELL trade with price and fees |
| Performance Tracking | Calculates average cost, market value, and unrealized gain/loss |
| Asset Allocation | Shows the percentage of each asset class in a portfolio |
| Rebalancing | Compares actual and target weights and suggests BUY/SELL amounts |
| Financial Reports | Client summary, transaction activity, and asset price performance |
| Access Control | Each client can see only their own portfolios through a view |
| Query Optimization | Uses composite and covering indexes with `EXPLAIN` |
 
## 🛠️ Technologies Used
 
| Technology | Purpose |
|---|---|
| MySQL 8.0+ | Relational database management |
| MySQL Workbench | Database development and SQL execution |
| SQL | Database creation, manipulation, and analysis |
| Draw.io | Entity Relationship Diagram design |
 
## 🗄️ Database Architecture
 
The database consists of **7 interconnected relational tables**.
 
| Table | Description |
|---|---|
| `clients` | Stores client details and risk profile |
| `asset_classes` | Stores asset categories |
| `assets` | Stores tradable assets (stocks, bonds, ETFs, REITs) |
| `asset_prices` | Stores daily closing prices (**weak entity**) |
| `portfolios` | Stores portfolios owned by clients |
| `investments` | Stores target allocation of assets in each portfolio |
| `transactions` | Stores all BUY and SELL trades |
 
### Weak Entity
 
`asset_prices` is the weak entity of the database. A price record cannot exist without its asset. It is identified by the owner key (`asset_id`) together with the partial key (`price_date`), which is enforced by a `UNIQUE` composite index and `ON DELETE CASCADE`.
 
### Database Relationships
 
- One client can own multiple portfolios.
- One portfolio can have many investments and many transactions.
- One asset can appear in many portfolios and many transactions.
- One asset class contains many assets.
- One asset has one price record per day (identifying relationship).
## 🧠 SQL Concepts Implemented
 
### 1. Database Design and Constraints
 
- Primary Keys
- Foreign Keys with `ON DELETE CASCADE`
- UNIQUE Constraints
- NOT NULL Constraints
- CHECK Constraints (positive price and quantity, valid allocation range)
- DEFAULT values and AUTO_INCREMENT
- ENUM data types
### 2. Indexing and Query Optimization
 
The project implements composite and covering indexes.
 
Indexes include:
 
- `idx_txn_portfolio_asset_date` on `transactions (portfolio_id, asset_id, transaction_date)`
- `idx_prices_asset_date` (UNIQUE) on `asset_prices (asset_id, price_date)`
- `idx_txn_report_cover` (covering) on `transactions (portfolio_id, asset_id, transaction_type, quantity, price)`
Execution plans were compared before and after indexing using `EXPLAIN`. The covering index gives `Using index` for the portfolio performance report.
 
A bulk-loading test with about 192,000 price rows showed that a table with extra secondary indexes loads noticeably slower than one with only a primary key (about 2.6x slower in the test run). This shows the trade-off between read speed and write speed.
 
### 3. SQL Views
 
| View | Purpose |
|---|---|
| `v_latest_prices` | Latest closing price of every asset |
| `v_portfolio_holdings` | Current quantity, average cost, market value, unrealized gain/loss |
| `v_asset_allocation` | Percentage per asset class in each portfolio |
| `v_client_holdings` | Client-specific view that shows only the logged-in client's holdings |
 
**Access control:** `v_client_holdings` filters rows using `USER()` and `clients.db_username`. Clients get `SELECT` permission only on this view, not on the base tables.
 
### 4. Window Functions
 
| Function | Application |
|---|---|
| `LAG()` | Daily return from previous day's price |
| `AVG() OVER()` | 7-day moving average of asset price |
| `RANK()` | Ranking of assets by return within each portfolio |
| `SUM() OVER (PARTITION BY portfolio_id)` | Asset weight and rebalancing flag (above 20% threshold) |
 
## 📁 Repository Structure
 
```text
.
├── Financial_Portfolio_Management.sql      # All 48 SQL queries in report order
├── Capstone_Project_Report_Financial_Portfolio_Management.docx
└── README.md
```
 
## ⚙️ Installation and Setup
 
### Prerequisites
 
- MySQL Server 8.0+
- MySQL Workbench
- Git (optional)
### Step 1: Clone the Repository
 
```bash
git clone https://github.com/Chirag-hub07/DBMS-Capstone-Project.git
```
 
### Step 2: Create the Database
 
Open MySQL Workbench and execute:
 
```sql
CREATE DATABASE portfolio_mysql;
 
USE portfolio_mysql;
```
 
### Step 3: Run the Script
 
Open `Financial_Portfolio_Management.sql` in MySQL Workbench and execute it in order. The script creates the tables, inserts the sample data, runs the analysis queries, creates the indexes and views, and sets up client accounts.
 
Tables are created in the following order:
 
1. `clients`
2. `asset_classes`
3. `assets`
4. `asset_prices`
5. `portfolios`
6. `investments`
7. `transactions`
### Step 4: Verify the Database
 
```sql
SHOW TABLES;
```
 
### Step 5: Test Holdings and Allocation
 
```sql
SELECT * FROM v_portfolio_holdings;
 
SELECT * FROM v_asset_allocation;
```
 
### Step 6: Test Client Access Control
 
Open a new connection logged in as `aarav` (password `Client@123`) and run:
 
```sql
SELECT * FROM portfolio_mysql.v_client_holdings;
```
 
Only Aarav's portfolios are shown. Running `SELECT * FROM portfolio_mysql.transactions;` as this user gives **Error 1142 (SELECT command denied)**. This is the expected result.
 
**Note:** Avoid rerunning non-idempotent `CREATE TABLE` and `INSERT` statements on an already populated database. Drop the database `portfolio_mysql` first if you want to run the full script again.
 
## 📊 Sample Dataset
 
| Entity | Records |
|---|---:|
| Clients | 5 |
| Asset Classes | 5 |
| Assets | 8 |
| Asset Prices | 80 (8 assets x 10 trading days) |
| Portfolios | 6 |
| Investments | 24 |
| Transactions | 43 |
 
## 🔍 Rebalancing Logic
 
Each portfolio has a rebalancing threshold (20% by default).
 
1. The market value of every holding is calculated from quantity and latest price.
2. The weight of each holding is calculated using `SUM() OVER (PARTITION BY portfolio_id)`.
3. Holdings with a weight above the threshold are flagged as `REBALANCE`.
4. The rebalancing query compares the current weight with the target allocation and returns the action (`BUY` or `SELL`) and the amount to trade.
## 📈 Investment Performance Analysis
 
**Holding Performance:** Average cost, current price, gain/loss, and return percentage for each holding.
 
**Portfolio Performance:** Total invested amount, market value, and overall return for each portfolio.
 
**Asset Allocation:** Share of each asset class in a portfolio.
 
**Daily Returns:** Day-to-day change in asset price using `LAG()`.
 
**Trend Smoothing:** 7-day moving average of asset price.
 
**Asset Ranking:** Assets ranked by return inside each portfolio.
 
## 🚀 Future Enhancements
 
- Dividend, tax, and currency conversion tables.
- Live market price feed integration.
- Web or mobile dashboard for clients.
- Partitioning for very large price histories.
- Automated rebalancing alerts.
- Larger datasets for realistic performance benchmarking.
## 📚 Learning Outcomes
 
This project demonstrates practical knowledge of:
 
- Relational Database Design
- Entity Relationship Modeling and Weak Entities
- SQL Constraints and Referential Integrity
- Aggregate Functions
- SQL Views and Access Control
- Window Functions
- Composite and Covering Indexing
- Query Execution Plans (`EXPLAIN`)
- Impact of Indexes on Bulk Loading
## 👨‍💻 Developer
 
**Chirag Virdi**
 
B.Tech – Computer Science and Engineering (Data Science)
 
K.R. Mangalam University
 
**Project:** Financial Portfolio Management System
 
**Domain:** Database Management Systems (DBMS)
 
**Project Type:** Academic Database Project
 
## 📖 References
 
- [MySQL Official Documentation](https://dev.mysql.com/doc/)
- [MySQL Workbench Documentation](https://dev.mysql.com/doc/workbench/en/)
- [MySQL Window Functions](https://dev.mysql.com/doc/refman/8.0/en/window-functions.html)
- [Draw.io](https://www.drawio.com/)
---
 
### ⭐ Support
 
If you find this project useful for learning SQL or Database Management Systems, consider giving the repository a star.
 
