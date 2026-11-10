-- ============================================================
-- Financial Portfolio Management System (MySQL)
-- Database Management Capstone Project
-- All SQL queries used in the report, in the same order
-- ============================================================

-- Query 1: Create the Database
CREATE DATABASE portfolio_mysql;

-- Query 2: Select the Database
USE portfolio_mysql;

-- Query 3: Create the Clients Table
CREATE TABLE clients (
  client_id    INT AUTO_INCREMENT PRIMARY KEY,
  full_name    VARCHAR(100) NOT NULL,
  email        VARCHAR(100) NOT NULL UNIQUE,
  db_username  VARCHAR(32)  NOT NULL UNIQUE,
  risk_profile ENUM('Conservative','Moderate','Aggressive') NOT NULL DEFAULT 'Moderate',
  joined_on    DATE NOT NULL DEFAULT (CURRENT_DATE)
);

-- Query 4: Create the Asset Classes Table
CREATE TABLE asset_classes (
  class_id   INT AUTO_INCREMENT PRIMARY KEY,
  class_name VARCHAR(50) NOT NULL UNIQUE
);

-- Query 5: Create the Assets Table
CREATE TABLE assets (
  asset_id   INT AUTO_INCREMENT PRIMARY KEY,
  symbol     VARCHAR(20)  NOT NULL UNIQUE,
  asset_name VARCHAR(100) NOT NULL,
  class_id   INT NOT NULL,
  sector     VARCHAR(50),
  FOREIGN KEY (class_id) REFERENCES asset_classes(class_id)
);

-- Query 6: Create the Asset Prices Table (Weak Entity)
CREATE TABLE asset_prices (
  price_id    INT AUTO_INCREMENT PRIMARY KEY,
  asset_id    INT NOT NULL,
  price_date  DATE NOT NULL,
  close_price DECIMAL(12,2) NOT NULL CHECK (close_price > 0),
  FOREIGN KEY (asset_id) REFERENCES assets(asset_id)
    ON DELETE CASCADE
);

-- Query 7: Create the Portfolios Table
CREATE TABLE portfolios (
  portfolio_id        INT AUTO_INCREMENT PRIMARY KEY,
  client_id           INT NOT NULL,
  portfolio_name      VARCHAR(100) NOT NULL,
  base_currency       CHAR(3) NOT NULL DEFAULT 'INR',
  rebalance_threshold DECIMAL(5,2) NOT NULL DEFAULT 20.00
                      CHECK (rebalance_threshold BETWEEN 1 AND 100),
  created_on          DATE NOT NULL DEFAULT (CURRENT_DATE),
  FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE
);

-- Query 8: Create the Investments Table
CREATE TABLE investments (
  investment_id     INT AUTO_INCREMENT PRIMARY KEY,
  portfolio_id      INT NOT NULL,
  asset_id          INT NOT NULL,
  target_allocation DECIMAL(5,2) NOT NULL CHECK (target_allocation BETWEEN 0 AND 100),
  start_date        DATE NOT NULL,
  UNIQUE (portfolio_id, asset_id),
  FOREIGN KEY (portfolio_id) REFERENCES portfolios(portfolio_id) ON DELETE CASCADE,
  FOREIGN KEY (asset_id)     REFERENCES assets(asset_id)
);

-- Query 9: Create the Transactions Table
CREATE TABLE transactions (
  transaction_id   INT AUTO_INCREMENT PRIMARY KEY,
  portfolio_id     INT NOT NULL,
  asset_id         INT NOT NULL,
  transaction_type ENUM('BUY','SELL') NOT NULL,
  quantity         DECIMAL(12,2) NOT NULL CHECK (quantity > 0),
  price            DECIMAL(12,2) NOT NULL CHECK (price > 0),
  fees             DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (fees >= 0),
  transaction_date DATE NOT NULL,
  FOREIGN KEY (portfolio_id) REFERENCES portfolios(portfolio_id),
  FOREIGN KEY (asset_id)     REFERENCES assets(asset_id)
);

-- Query 10: Display All Tables
SHOW TABLES;

-- Query 11: Insert Data into Clients
INSERT INTO clients (full_name, email, db_username, risk_profile)
VALUES
  ('Aarav Sharma', 'aarav.sharma@example.com', 'aarav', 'Moderate'),
  ('Priya Verma', 'priya.verma@example.com', 'priya', 'Conservative'),
  ('Rohan Mehta', 'rohan.mehta@example.com', 'rohan', 'Aggressive'),
  ('Ananya Gupta', 'ananya.gupta@example.com', 'ananya', 'Moderate'),
  ('Rahul Singh', 'rahul.singh@example.com', 'rahul', 'Aggressive');

-- Query 12: Insert Data into Asset Classes
INSERT INTO asset_classes (class_name)
VALUES
  ('Equity'),
  ('Bond'),
  ('Commodity'),
  ('Mutual Fund'),
  ('Real Estate');

-- Query 13: Insert Data into Assets
INSERT INTO assets (symbol, asset_name, class_id, sector)
VALUES
  ('RELIANCE', 'Reliance Industries Ltd', 1, 'Energy'),
  ('TCS', 'Tata Consultancy Services', 1, 'Information Technology'),
  ('HDFCBANK', 'HDFC Bank Ltd', 1, 'Banking'),
  ('GOI10Y', 'Government of India 10Y Bond', 2, 'Government'),
  ('GOLDBEES', 'Nippon Gold BeES ETF', 3, 'Gold'),
  ('NIFTYBEES', 'Nippon Nifty 50 BeES ETF', 4, 'Index Fund'),
  ('EMBASSY', 'Embassy Office Parks REIT', 5, 'Commercial Property'),
  ('CORPBOND', 'HDFC Corporate Bond Fund', 2, 'Corporate');

-- Query 14: Insert Data into Asset Prices
INSERT INTO asset_prices (asset_id, price_date, close_price)
VALUES
  (1, '2026-10-26', 1447.0),
  (1, '2026-10-27', 1457.33),
  (1, '2026-10-28', 1454.83),
  (1, '2026-10-29', 1450.78),
  (1, '2026-10-30', 1436.04),
  (1, '2026-11-02', 1433.8),
  (1, '2026-11-03', 1454.37),
  (1, '2026-11-04', 1463.22),
  (1, '2026-11-05', 1482.89),
  (1, '2026-11-06', 1488.81),
  (2, '2026-10-26', 3919.3),
  (2, '2026-10-27', 3930.48),
  (2, '2026-10-28', 3868.93),
  (2, '2026-10-29', 3905.88),
  (2, '2026-10-30', 3929.57),
  (2, '2026-11-02', 3953.1),
  (2, '2026-11-03', 3890.19),
  (2, '2026-11-04', 3826.24),
  (2, '2026-11-05', 3796.03),
  (2, '2026-11-06', 3782.05),
  (3, '2026-10-26', 1657.19),
  (3, '2026-10-27', 1658.01),
  (3, '2026-10-28', 1669.17),
  (3, '2026-10-29', 1659.05),
  (3, '2026-10-30', 1666.34),
  (3, '2026-11-02', 1675.23),
  (3, '2026-11-03', 1664.73),
  (3, '2026-11-04', 1697.84),
  (3, '2026-11-05', 1709.94),
  (3, '2026-11-06', 1734.16),
  (4, '2026-10-26', 1019.75),
  (4, '2026-10-27', 1019.27),
  (4, '2026-10-28', 1019.58),
  (4, '2026-10-29', 1020.39),
  (4, '2026-10-30', 1022.7),
  (4, '2026-11-02', 1024.23),
  (4, '2026-11-03', 1024.34),
  (4, '2026-11-04', 1023.4),
  (4, '2026-11-05', 1023.36),
  (4, '2026-11-06', 1026.88),
  (5, '2026-10-26', 74.59),
  (5, '2026-10-27', 74.81),
  (5, '2026-10-28', 75.14),
  (5, '2026-10-29', 74.32),
  (5, '2026-10-30', 74.42),
  (5, '2026-11-02', 75.28),
  (5, '2026-11-03', 74.14),
  (5, '2026-11-04', 74.02),
  (5, '2026-11-05', 74.03),
  (5, '2026-11-06', 73.62),
  (6, '2026-10-26', 271.21),
  (6, '2026-10-27', 271.36),
  (6, '2026-10-28', 268.85),
  (6, '2026-10-29', 270.68),
  (6, '2026-10-30', 272.22),
  (6, '2026-11-02', 274.29),
  (6, '2026-11-03', 277.33),
  (6, '2026-11-04', 278.31),
  (6, '2026-11-05', 278.82),
  (6, '2026-11-06', 276.57),
  (7, '2026-10-26', 392.55),
  (7, '2026-10-27', 390.78),
  (7, '2026-10-28', 389.58),
  (7, '2026-10-29', 385.54),
  (7, '2026-10-30', 382.56),
  (7, '2026-11-02', 381.12),
  (7, '2026-11-03', 385.92),
  (7, '2026-11-04', 379.25),
  (7, '2026-11-05', 374.65),
  (7, '2026-11-06', 375.83),
  (8, '2026-10-26', 1105.86),
  (8, '2026-10-27', 1108.89),
  (8, '2026-10-28', 1103.68),
  (8, '2026-10-29', 1096.44),
  (8, '2026-10-30', 1098.71),
  (8, '2026-11-02', 1097.39),
  (8, '2026-11-03', 1094.8),
  (8, '2026-11-04', 1099.1),
  (8, '2026-11-05', 1103.83),
  (8, '2026-11-06', 1105.46);

-- Query 15: Insert Data into Portfolios
INSERT INTO portfolios (client_id, portfolio_name)
VALUES
  (1, 'Aarav Growth Portfolio'),
  (1, 'Aarav Retirement Portfolio'),
  (2, 'Priya Safe Income Portfolio'),
  (3, 'Rohan Aggressive Portfolio'),
  (4, 'Ananya Balanced Portfolio'),
  (5, 'Rahul Trading Portfolio');

-- Query 16: Insert Data into Investments
INSERT INTO investments (portfolio_id, asset_id, target_allocation, start_date)
VALUES
  (1, 1, 25, '2026-10-26'),
  (1, 2, 25, '2026-10-26'),
  (1, 3, 20, '2026-10-26'),
  (1, 5, 15, '2026-10-26'),
  (1, 6, 15, '2026-10-26'),
  (2, 4, 40, '2026-10-26'),
  (2, 6, 30, '2026-10-26'),
  (2, 5, 15, '2026-10-26'),
  (2, 7, 15, '2026-10-26'),
  (3, 4, 40, '2026-10-26'),
  (3, 8, 40, '2026-10-26'),
  (3, 5, 20, '2026-10-26'),
  (4, 1, 30, '2026-10-26'),
  (4, 2, 30, '2026-10-26'),
  (4, 3, 25, '2026-10-26'),
  (4, 7, 15, '2026-10-26'),
  (5, 1, 20, '2026-10-26'),
  (5, 6, 25, '2026-10-26'),
  (5, 8, 25, '2026-10-26'),
  (5, 5, 15, '2026-10-26'),
  (5, 7, 15, '2026-10-26'),
  (6, 2, 40, '2026-10-26'),
  (6, 3, 30, '2026-10-26'),
  (6, 6, 30, '2026-10-26');

-- Query 17: Insert Data into Transactions
INSERT INTO transactions (portfolio_id, asset_id, transaction_type, quantity, price, fees, transaction_date)
VALUES
  (1, 1, 'BUY', 152, 1447.0, 109.97, '2026-10-26'),
  (1, 2, 'BUY', 59, 3919.3, 115.62, '2026-10-26'),
  (2, 4, 'BUY', 189, 1019.75, 96.37, '2026-10-26'),
  (2, 6, 'BUY', 579, 271.21, 78.52, '2026-10-26'),
  (4, 1, 'BUY', 221, 1447.0, 159.89, '2026-10-26'),
  (4, 2, 'BUY', 94, 3919.3, 184.21, '2026-10-26'),
  (5, 6, 'BUY', 823, 271.21, 111.6, '2026-10-26'),
  (5, 8, 'BUY', 186, 1105.86, 102.84, '2026-10-26'),
  (5, 7, 'BUY', 285, 392.55, 55.94, '2026-10-26'),
  (6, 2, 'BUY', 101, 3919.3, 197.92, '2026-10-26'),
  (6, 3, 'BUY', 196, 1657.19, 162.4, '2026-10-26'),
  (6, 6, 'BUY', 895, 271.21, 121.37, '2026-10-26'),
  (1, 3, 'BUY', 103, 1658.01, 85.39, '2026-10-27'),
  (1, 6, 'BUY', 565, 271.36, 76.66, '2026-10-27'),
  (2, 5, 'BUY', 1535, 74.81, 57.42, '2026-10-27'),
  (3, 8, 'BUY', 201, 1108.89, 111.44, '2026-10-27'),
  (3, 5, 'BUY', 1177, 74.81, 44.03, '2026-10-27'),
  (4, 3, 'BUY', 166, 1658.01, 137.61, '2026-10-27'),
  (4, 7, 'BUY', 399, 390.78, 77.96, '2026-10-27'),
  (5, 5, 'BUY', 1486, 74.81, 55.58, '2026-10-27'),
  (1, 5, 'BUY', 1499, 75.14, 56.32, '2026-10-28'),
  (2, 7, 'BUY', 260, 389.58, 50.65, '2026-10-28'),
  (3, 4, 'BUY', 235, 1019.58, 119.8, '2026-10-28'),
  (5, 1, 'BUY', 89, 1454.83, 64.74, '2026-10-28'),
  (3, 8, 'BUY', 60, 1098.71, 32.96, '2026-10-30'),
  (3, 5, 'BUY', 353, 74.42, 13.14, '2026-10-30'),
  (4, 3, 'BUY', 49, 1666.34, 40.83, '2026-10-30'),
  (5, 8, 'BUY', 55, 1098.71, 30.21, '2026-10-30'),
  (6, 6, 'BUY', 268, 272.22, 36.48, '2026-10-30'),
  (1, 1, 'BUY', 45, 1433.8, 32.26, '2026-11-02'),
  (1, 6, 'BUY', 169, 274.29, 23.18, '2026-11-02'),
  (4, 7, 'BUY', 119, 381.12, 22.68, '2026-11-02'),
  (1, 5, 'BUY', 449, 74.14, 16.64, '2026-11-03'),
  (1, 2, 'BUY', 17, 3826.24, 32.52, '2026-11-04'),
  (3, 4, 'BUY', 70, 1023.4, 35.82, '2026-11-04'),
  (5, 1, 'SELL', 17, 1463.22, 12.44, '2026-11-04'),
  (1, 2, 'SELL', 11, 3796.03, 20.88, '2026-11-05'),
  (2, 4, 'SELL', 37, 1023.36, 18.93, '2026-11-05'),
  (4, 2, 'SELL', 18, 3796.03, 34.16, '2026-11-05'),
  (4, 7, 'SELL', 79, 374.65, 14.8, '2026-11-05'),
  (1, 6, 'SELL', 113, 276.57, 15.63, '2026-11-06'),
  (3, 5, 'SELL', 235, 73.62, 8.65, '2026-11-06'),
  (5, 6, 'SELL', 164, 276.57, 22.68, '2026-11-06');

-- Query 18: Verify Row Counts of All Tables
SELECT 'clients' AS table_name, COUNT(*) AS total_rows FROM clients
UNION ALL SELECT 'asset_classes', COUNT(*) FROM asset_classes
UNION ALL SELECT 'assets', COUNT(*) FROM assets
UNION ALL SELECT 'asset_prices', COUNT(*) FROM asset_prices
UNION ALL SELECT 'portfolios', COUNT(*) FROM portfolios
UNION ALL SELECT 'investments', COUNT(*) FROM investments
UNION ALL SELECT 'transactions', COUNT(*) FROM transactions;

-- Query 19: Track Investment Performance of Each Holding
WITH h AS (
  SELECT portfolio_id, asset_id,
         SUM(CASE WHEN transaction_type = 'BUY' THEN quantity ELSE -quantity END) AS qty,
         SUM(CASE WHEN transaction_type = 'BUY' THEN quantity * price ELSE 0 END)
           / SUM(CASE WHEN transaction_type = 'BUY' THEN quantity ELSE 0 END) AS avg_cost
  FROM transactions
  GROUP BY portfolio_id, asset_id
)
SELECT p.portfolio_name, a.symbol, h.qty AS quantity,
       ROUND(h.avg_cost, 2) AS avg_cost, lp.close_price AS current_price,
       ROUND(h.qty * (lp.close_price - h.avg_cost), 2) AS gain_loss,
       ROUND((lp.close_price - h.avg_cost) * 100 / h.avg_cost, 2) AS return_pct
FROM h
JOIN portfolios p ON p.portfolio_id = h.portfolio_id
JOIN assets a ON a.asset_id = h.asset_id
JOIN asset_prices lp ON lp.asset_id = h.asset_id
   AND lp.price_date = (SELECT MAX(price_date) FROM asset_prices WHERE asset_id = h.asset_id)
WHERE h.qty > 0
ORDER BY p.portfolio_id, return_pct DESC
LIMIT 10;

-- Query 20: Portfolio-Level Investment Performance
WITH h AS (
  SELECT portfolio_id, asset_id,
         SUM(CASE WHEN transaction_type = 'BUY' THEN quantity ELSE -quantity END) AS qty,
         SUM(CASE WHEN transaction_type = 'BUY' THEN quantity * price ELSE 0 END)
           / SUM(CASE WHEN transaction_type = 'BUY' THEN quantity ELSE 0 END) AS avg_cost
  FROM transactions
  GROUP BY portfolio_id, asset_id
)
SELECT p.portfolio_name, c.full_name AS client,
       ROUND(SUM(h.qty * h.avg_cost), 2) AS invested,
       ROUND(SUM(h.qty * lp.close_price), 2) AS market_value,
       ROUND(SUM(h.qty * (lp.close_price - h.avg_cost)), 2) AS gain_loss,
       ROUND(SUM(h.qty * (lp.close_price - h.avg_cost)) * 100
             / SUM(h.qty * h.avg_cost), 2) AS return_pct
FROM h
JOIN portfolios p ON p.portfolio_id = h.portfolio_id
JOIN clients c ON c.client_id = p.client_id
JOIN asset_prices lp ON lp.asset_id = h.asset_id
   AND lp.price_date = (SELECT MAX(price_date) FROM asset_prices WHERE asset_id = h.asset_id)
WHERE h.qty > 0
GROUP BY p.portfolio_id, p.portfolio_name, c.full_name;

-- Query 21: Analyze Asset Allocation by Asset Class
WITH h AS (
  SELECT portfolio_id, asset_id,
         SUM(CASE WHEN transaction_type = 'BUY' THEN quantity ELSE -quantity END) AS qty,
         SUM(CASE WHEN transaction_type = 'BUY' THEN quantity * price ELSE 0 END)
           / SUM(CASE WHEN transaction_type = 'BUY' THEN quantity ELSE 0 END) AS avg_cost
  FROM transactions
  GROUP BY portfolio_id, asset_id
)
SELECT ac.class_name,
       ROUND(SUM(h.qty * lp.close_price), 2) AS class_value,
       ROUND(SUM(h.qty * lp.close_price) * 100
             / SUM(SUM(h.qty * lp.close_price)) OVER (), 2) AS allocation_pct
FROM h
JOIN assets a ON a.asset_id = h.asset_id
JOIN asset_classes ac ON ac.class_id = a.class_id
JOIN asset_prices lp ON lp.asset_id = h.asset_id
   AND lp.price_date = (SELECT MAX(price_date) FROM asset_prices WHERE asset_id = h.asset_id)
WHERE h.portfolio_id = 1 AND h.qty > 0
GROUP BY ac.class_name
ORDER BY allocation_pct DESC;

-- Query 22: Rebalance a Portfolio
WITH h AS (
  SELECT portfolio_id, asset_id,
         SUM(CASE WHEN transaction_type = 'BUY' THEN quantity ELSE -quantity END) AS qty,
         SUM(CASE WHEN transaction_type = 'BUY' THEN quantity * price ELSE 0 END)
           / SUM(CASE WHEN transaction_type = 'BUY' THEN quantity ELSE 0 END) AS avg_cost
  FROM transactions
  GROUP BY portfolio_id, asset_id
),
v AS (
  SELECT h.portfolio_id, h.asset_id, h.qty * lp.close_price AS mv
  FROM h
  JOIN asset_prices lp ON lp.asset_id = h.asset_id
   AND lp.price_date = (SELECT MAX(price_date) FROM asset_prices WHERE asset_id = h.asset_id)
  WHERE h.qty > 0
),
w AS (
  SELECT portfolio_id, asset_id, mv,
         SUM(mv) OVER (PARTITION BY portfolio_id) AS total_value,
         ROUND(mv * 100 / SUM(mv) OVER (PARTITION BY portfolio_id), 2) AS current_pct
  FROM v
)
SELECT a.symbol, w.current_pct, i.target_allocation AS target_pct,
       ROUND(i.target_allocation - w.current_pct, 2) AS drift,
       CASE WHEN i.target_allocation > w.current_pct THEN 'BUY' ELSE 'SELL' END AS action,
       ROUND(ABS(i.target_allocation - w.current_pct) * w.total_value / 100, 2) AS amount
FROM w
JOIN investments i ON i.portfolio_id = w.portfolio_id AND i.asset_id = w.asset_id
JOIN assets a ON a.asset_id = w.asset_id
WHERE w.portfolio_id = 4;

-- Query 23: Financial Report: Client Summary
WITH h AS (
  SELECT portfolio_id, asset_id,
         SUM(CASE WHEN transaction_type = 'BUY' THEN quantity ELSE -quantity END) AS qty,
         SUM(CASE WHEN transaction_type = 'BUY' THEN quantity * price ELSE 0 END)
           / SUM(CASE WHEN transaction_type = 'BUY' THEN quantity ELSE 0 END) AS avg_cost
  FROM transactions
  GROUP BY portfolio_id, asset_id
)
SELECT c.full_name, c.risk_profile, COUNT(DISTINCT p.portfolio_id) AS portfolios,
       ROUND(SUM(h.qty * lp.close_price), 2) AS total_value,
       ROUND(SUM(h.qty * (lp.close_price - h.avg_cost)), 2) AS total_gain_loss
FROM h
JOIN portfolios p ON p.portfolio_id = h.portfolio_id
JOIN clients c ON c.client_id = p.client_id
JOIN asset_prices lp ON lp.asset_id = h.asset_id
   AND lp.price_date = (SELECT MAX(price_date) FROM asset_prices WHERE asset_id = h.asset_id)
WHERE h.qty > 0
GROUP BY c.client_id, c.full_name, c.risk_profile
ORDER BY total_value DESC;

-- Query 24: Financial Report: Transaction Activity
SELECT p.portfolio_name, COUNT(*) AS total_trades,
       ROUND(SUM(CASE WHEN t.transaction_type = 'BUY'  THEN t.quantity * t.price ELSE 0 END), 2) AS total_bought,
       ROUND(SUM(CASE WHEN t.transaction_type = 'SELL' THEN t.quantity * t.price ELSE 0 END), 2) AS total_sold,
       SUM(t.fees) AS total_fees
FROM transactions t
JOIN portfolios p ON p.portfolio_id = t.portfolio_id
GROUP BY p.portfolio_id, p.portfolio_name
ORDER BY total_trades DESC;

-- Query 25: Financial Report: Asset Price Performance
SELECT a.symbol, f.close_price AS start_price, l.close_price AS end_price,
       ROUND((l.close_price - f.close_price) * 100 / f.close_price, 2) AS period_return_pct
FROM assets a
JOIN asset_prices f ON f.asset_id = a.asset_id
  AND f.price_date = (SELECT MIN(price_date) FROM asset_prices WHERE asset_id = a.asset_id)
JOIN asset_prices l ON l.asset_id = a.asset_id
  AND l.price_date = (SELECT MAX(price_date) FROM asset_prices WHERE asset_id = a.asset_id)
ORDER BY period_return_pct DESC;

-- Query 26: EXPLAIN on Transactions Before Composite Index
EXPLAIN SELECT * FROM transactions
WHERE portfolio_id = 1 AND asset_id = 1
  AND transaction_date BETWEEN '2026-10-26' AND '2026-11-06';

-- Query 27: EXPLAIN on Asset Prices Before Composite Index
EXPLAIN SELECT * FROM asset_prices
WHERE asset_id = 1
  AND price_date BETWEEN '2026-10-28' AND '2026-11-03';

-- Query 28: Create Composite Indexes
CREATE INDEX idx_txn_portfolio_asset_date
  ON transactions (portfolio_id, asset_id, transaction_date);
CREATE UNIQUE INDEX idx_prices_asset_date
  ON asset_prices (asset_id, price_date);

-- Query 29: EXPLAIN on Transactions After Composite Index
EXPLAIN SELECT * FROM transactions
WHERE portfolio_id = 1 AND asset_id = 1
  AND transaction_date BETWEEN '2026-10-26' AND '2026-11-06';

-- Query 30: EXPLAIN on Asset Prices After Composite Index
EXPLAIN SELECT * FROM asset_prices
WHERE asset_id = 1
  AND price_date BETWEEN '2026-10-28' AND '2026-11-03';

-- Query 31: EXPLAIN on Portfolio Performance Report (Without Covering Index)
EXPLAIN SELECT asset_id, transaction_type, SUM(quantity) AS total_qty,
       SUM(quantity * price) AS total_value
FROM transactions
WHERE portfolio_id = 1
GROUP BY asset_id, transaction_type;

-- Query 32: Create a Covering Index for the Performance Report
CREATE INDEX idx_txn_report_cover
  ON transactions (portfolio_id, asset_id, transaction_type, quantity, price);

-- Query 33: EXPLAIN on Portfolio Performance Report (With Covering Index)
EXPLAIN SELECT asset_id, transaction_type, SUM(quantity) AS total_qty,
       SUM(quantity * price) AS total_value
FROM transactions
WHERE portfolio_id = 1
GROUP BY asset_id, transaction_type;

-- Query 34: Bulk Loading Historical Prices Without Secondary Indexes
CREATE TABLE asset_prices_bulk (
  price_id    INT AUTO_INCREMENT PRIMARY KEY,
  asset_id    INT NOT NULL,
  price_date  DATE NOT NULL,
  close_price DECIMAL(12,2) NOT NULL
);
INSERT INTO asset_prices_bulk (asset_id, price_date, close_price)
SELECT p1.asset_id,
       DATE_ADD(p1.price_date, INTERVAL p2.price_id + p3.price_id * 80 DAY),
       ROUND(p1.close_price * (1 + p2.price_id / 1000), 2)
FROM asset_prices p1
CROSS JOIN asset_prices p2
CROSS JOIN asset_prices p3
WHERE p3.price_id <= 30;

-- Query 35: Bulk Loading Historical Prices With Secondary Indexes
CREATE TABLE asset_prices_bulk_idx (
  price_id    INT AUTO_INCREMENT PRIMARY KEY,
  asset_id    INT NOT NULL,
  price_date  DATE NOT NULL,
  close_price DECIMAL(12,2) NOT NULL,
  INDEX idx_a (asset_id, price_date),
  INDEX idx_b (price_date, asset_id, close_price)
);
INSERT INTO asset_prices_bulk_idx (asset_id, price_date, close_price)
SELECT p1.asset_id,
       DATE_ADD(p1.price_date, INTERVAL p2.price_id + p3.price_id * 80 DAY),
       ROUND(p1.close_price * (1 + p2.price_id / 1000), 2)
FROM asset_prices p1
CROSS JOIN asset_prices p2
CROSS JOIN asset_prices p3
WHERE p3.price_id <= 30;

-- Query 36: Create the Latest Prices View
CREATE VIEW v_latest_prices AS
SELECT p.asset_id, p.price_date, p.close_price
FROM asset_prices p
WHERE p.price_date = (SELECT MAX(price_date) FROM asset_prices WHERE asset_id = p.asset_id);

-- Query 37: Create the Portfolio Holdings View
CREATE VIEW v_portfolio_holdings AS
SELECT h.portfolio_id, h.asset_id, a.symbol, ac.class_name,
       h.current_quantity, h.average_cost,
       lp.close_price AS current_price,
       ROUND(h.current_quantity * lp.close_price, 2) AS market_value,
       ROUND(h.current_quantity * (lp.close_price - h.average_cost), 2) AS unrealized_gain_loss
FROM (
  SELECT portfolio_id, asset_id,
         SUM(CASE WHEN transaction_type = 'BUY' THEN quantity ELSE -quantity END) AS current_quantity,
         ROUND(SUM(CASE WHEN transaction_type = 'BUY' THEN quantity * price ELSE 0 END)
           / SUM(CASE WHEN transaction_type = 'BUY' THEN quantity ELSE 0 END), 2) AS average_cost
  FROM transactions
  GROUP BY portfolio_id, asset_id
) h
JOIN assets a ON a.asset_id = h.asset_id
JOIN asset_classes ac ON ac.class_id = a.class_id
JOIN v_latest_prices lp ON lp.asset_id = h.asset_id
WHERE h.current_quantity > 0;

-- Query 38: Query the Portfolio Holdings View
SELECT symbol, class_name, current_quantity, average_cost, current_price,
       market_value, unrealized_gain_loss
FROM v_portfolio_holdings
WHERE portfolio_id = 1;

-- Query 39: Create the Asset Allocation View
CREATE VIEW v_asset_allocation AS
SELECT portfolio_id, class_name,
       ROUND(SUM(market_value), 2) AS class_value,
       ROUND(SUM(market_value) * 100
             / SUM(SUM(market_value)) OVER (PARTITION BY portfolio_id), 2) AS allocation_pct
FROM v_portfolio_holdings
GROUP BY portfolio_id, class_name;

-- Query 40: Query the Asset Allocation View
SELECT * FROM v_asset_allocation
WHERE portfolio_id = 2
ORDER BY allocation_pct DESC;

-- Query 41: Create the Client-Specific View
CREATE VIEW v_client_holdings AS
SELECT p.portfolio_name, h.symbol, h.class_name, h.current_quantity,
       h.average_cost, h.current_price, h.market_value, h.unrealized_gain_loss
FROM v_portfolio_holdings h
JOIN portfolios p ON p.portfolio_id = h.portfolio_id
JOIN clients c ON c.client_id = p.client_id
WHERE c.db_username = SUBSTRING_INDEX(USER(), '@', 1);

-- Query 42: Create Client Accounts and Grant Access
CREATE USER IF NOT EXISTS 'aarav'@'localhost' IDENTIFIED BY 'Client@123';
CREATE USER IF NOT EXISTS 'priya'@'localhost' IDENTIFIED BY 'Client@123';
CREATE USER IF NOT EXISTS 'rohan'@'localhost' IDENTIFIED BY 'Client@123';
CREATE USER IF NOT EXISTS 'ananya'@'localhost' IDENTIFIED BY 'Client@123';
CREATE USER IF NOT EXISTS 'rahul'@'localhost' IDENTIFIED BY 'Client@123';
GRANT SELECT ON portfolio_mysql.v_client_holdings TO 'aarav'@'localhost';
GRANT SELECT ON portfolio_mysql.v_client_holdings TO 'priya'@'localhost';
GRANT SELECT ON portfolio_mysql.v_client_holdings TO 'rohan'@'localhost';
GRANT SELECT ON portfolio_mysql.v_client_holdings TO 'ananya'@'localhost';
GRANT SELECT ON portfolio_mysql.v_client_holdings TO 'rahul'@'localhost';

-- Query 43: Test Access as Client Aarav
-- Run this query in a new connection logged in as aarav (password: Client@123)
-- SELECT * FROM v_client_holdings;

-- Query 44: Test Restricted Access to Base Tables
-- Run this query in a new connection logged in as aarav (password: Client@123)
-- Expected result: Error 1142 - SELECT command denied (this is the intended output)
-- SELECT * FROM transactions;

-- Query 45: Daily Returns Using LAG()
SELECT p.price_date, p.close_price,
       LAG(p.close_price) OVER w AS prev_close,
       ROUND((p.close_price - LAG(p.close_price) OVER w) * 100
             / LAG(p.close_price) OVER w, 2) AS daily_return_pct
FROM asset_prices p
JOIN assets a ON a.asset_id = p.asset_id
WHERE a.symbol = 'RELIANCE'
WINDOW w AS (PARTITION BY p.asset_id ORDER BY p.price_date)
ORDER BY p.price_date;

-- Query 46: 7-Day Moving Average Using AVG() OVER
SELECT p.price_date, p.close_price,
       ROUND(AVG(p.close_price) OVER (
         PARTITION BY p.asset_id ORDER BY p.price_date
         ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS moving_avg_7day
FROM asset_prices p
JOIN assets a ON a.asset_id = p.asset_id
WHERE a.symbol = 'TCS'
ORDER BY p.price_date;

-- Query 47: Rank Assets by Return Using RANK()
SELECT portfolio_id, symbol,
       ROUND((current_price - average_cost) * 100 / average_cost, 2) AS return_pct,
       RANK() OVER (PARTITION BY portfolio_id
                    ORDER BY (current_price - average_cost) / average_cost DESC) AS return_rank
FROM v_portfolio_holdings
WHERE portfolio_id IN (1, 4)
ORDER BY portfolio_id, return_rank;

-- Query 48: Asset Weights and Rebalancing Flag Using SUM() OVER
SELECT t.portfolio_id, t.symbol, t.market_value, t.portfolio_value, t.weight_pct,
       CASE WHEN t.weight_pct > p.rebalance_threshold
            THEN 'REBALANCE' ELSE 'OK' END AS status
FROM (
  SELECT portfolio_id, symbol, market_value,
         SUM(market_value) OVER (PARTITION BY portfolio_id) AS portfolio_value,
         ROUND(market_value * 100
               / SUM(market_value) OVER (PARTITION BY portfolio_id), 2) AS weight_pct
  FROM v_portfolio_holdings
) t
JOIN portfolios p ON p.portfolio_id = t.portfolio_id
WHERE t.portfolio_id IN (1, 3)
ORDER BY t.portfolio_id, t.weight_pct DESC;
