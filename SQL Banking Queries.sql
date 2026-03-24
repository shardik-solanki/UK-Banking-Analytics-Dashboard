-- ══════════════════════════════════════════════════════════
-- UK BANKING TRANSACTIONS — SQL ANALYSIS QUERIES
-- Project by: Hardik Solanki | Finance & Data Analyst
-- Dataset: 5,000 transactions across 5 UK banks 2022-2024
-- Tools: SQLite / PostgreSQL compatible
-- ══════════════════════════════════════════════════════════

-- ── SETUP: Create the transactions table ─────────────────
CREATE TABLE IF NOT EXISTS banking_transactions (
    Transaction_ID          TEXT PRIMARY KEY,
    Date                    DATE,
    Year                    INTEGER,
    Quarter                 TEXT,
    Month_Year              TEXT,
    Month_Name              TEXT,
    Bank                    TEXT,
    Region                  TEXT,
    Product                 TEXT,
    Segment                 TEXT,
    Channel                 TEXT,
    Currency                TEXT,
    Transaction_Value_GBP   DECIMAL(15,2),
    Margin_Pct              DECIMAL(5,2),
    Revenue_GBP             DECIMAL(10,2),
    Operating_Cost_GBP      DECIMAL(10,2),
    Net_Revenue_GBP         DECIMAL(10,2),
    Status                  TEXT,
    Risk_Rating             TEXT,
    Customer_Age            INTEGER,
    Credit_Score            INTEGER,
    Is_Digital              INTEGER,
    Is_Flagged              INTEGER
);

-- ── QUERY 1: Total Revenue by Bank ───────────────────────
-- Purpose: Compare revenue performance across all banks
SELECT
    Bank,
    COUNT(*)                                        AS Total_Transactions,
    ROUND(SUM(Revenue_GBP), 0)                      AS Total_Revenue_GBP,
    ROUND(SUM(Net_Revenue_GBP), 0)                  AS Total_Net_Revenue_GBP,
    ROUND(AVG(Margin_Pct), 2)                       AS Avg_Margin_Pct,
    ROUND(SUM(Revenue_GBP) * 100.0 /
          SUM(SUM(Revenue_GBP)) OVER(), 1)          AS Market_Share_Pct
FROM banking_transactions
GROUP BY Bank
ORDER BY Total_Revenue_GBP DESC;

-- ── QUERY 2: Revenue by Product — Most Profitable ────────
-- Purpose: Identify highest revenue generating products
SELECT
    Product,
    COUNT(*)                                        AS Transaction_Count,
    ROUND(SUM(Revenue_GBP), 0)                      AS Total_Revenue_GBP,
    ROUND(AVG(Transaction_Value_GBP), 0)            AS Avg_Transaction_Value,
    ROUND(AVG(Margin_Pct), 2)                       AS Avg_Margin_Pct,
    ROUND(SUM(Revenue_GBP) * 100.0 /
          SUM(SUM(Revenue_GBP)) OVER(), 1)          AS Revenue_Share_Pct
FROM banking_transactions
GROUP BY Product
ORDER BY Total_Revenue_GBP DESC;

-- ── QUERY 3: Quarterly Revenue Trend ─────────────────────
-- Purpose: Track revenue growth quarter by quarter
SELECT
    Year,
    Quarter,
    COUNT(*)                                        AS Transactions,
    ROUND(SUM(Revenue_GBP), 0)                      AS Revenue_GBP,
    ROUND(SUM(Net_Revenue_GBP), 0)                  AS Net_Revenue_GBP,
    ROUND(AVG(Transaction_Value_GBP), 0)            AS Avg_Transaction_Value,
    ROUND(SUM(Revenue_GBP) -
          LAG(SUM(Revenue_GBP)) OVER
          (ORDER BY Year, Quarter), 0)              AS Revenue_Change_vs_Prior_Qtr
FROM banking_transactions
GROUP BY Year, Quarter
ORDER BY Year, Quarter;

-- ── QUERY 4: Digital vs Traditional Channels ─────────────
-- Purpose: Measure digital adoption rate and revenue split
SELECT
    CASE WHEN Is_Digital = 1
         THEN 'Digital (Online/Mobile)'
         ELSE 'Traditional (Branch/ATM/Phone)'
    END                                             AS Channel_Type,
    Channel,
    COUNT(*)                                        AS Transactions,
    ROUND(SUM(Revenue_GBP), 0)                      AS Revenue_GBP,
    ROUND(AVG(Transaction_Value_GBP), 0)            AS Avg_Transaction_Value,
    ROUND(COUNT(*) * 100.0 /
          SUM(COUNT(*)) OVER(), 1)                  AS Share_Pct
FROM banking_transactions
GROUP BY Is_Digital, Channel
ORDER BY Is_Digital DESC, Revenue_GBP DESC;

-- ── QUERY 5: Risk Portfolio Analysis ─────────────────────
-- Purpose: Understand risk distribution and flagged transactions
SELECT
    Bank,
    Risk_Rating,
    COUNT(*)                                        AS Transaction_Count,
    ROUND(SUM(Transaction_Value_GBP), 0)            AS Total_Exposure_GBP,
    SUM(Is_Flagged)                                 AS Flagged_Count,
    ROUND(SUM(Is_Flagged) * 100.0 / COUNT(*), 1)   AS Flag_Rate_Pct,
    ROUND(AVG(Credit_Score), 0)                     AS Avg_Credit_Score
FROM banking_transactions
GROUP BY Bank, Risk_Rating
ORDER BY Bank, CASE Risk_Rating
    WHEN 'High' THEN 1
    WHEN 'Medium' THEN 2
    ELSE 3 END;

-- ── QUERY 6: Top 10 Regions by Revenue ───────────────────
SELECT
    Region,
    COUNT(*)                                        AS Transactions,
    ROUND(SUM(Revenue_GBP), 0)                      AS Total_Revenue_GBP,
    ROUND(AVG(Transaction_Value_GBP), 0)            AS Avg_Transaction_Value,
    ROUND(AVG(Margin_Pct), 2)                       AS Avg_Margin_Pct
FROM banking_transactions
GROUP BY Region
ORDER BY Total_Revenue_GBP DESC
LIMIT 10;

-- ── QUERY 7: Bank Performance Scorecard ──────────────────
-- Purpose: Full KPI scorecard per bank for management report
SELECT
    Bank,
    COUNT(*)                                        AS Total_Transactions,
    ROUND(SUM(Transaction_Value_GBP)/1000000, 1)    AS Portfolio_Value_GBPm,
    ROUND(SUM(Revenue_GBP)/1000, 0)                 AS Revenue_GBPk,
    ROUND(SUM(Net_Revenue_GBP)/1000, 0)             AS Net_Revenue_GBPk,
    ROUND(AVG(Margin_Pct), 2)                       AS Avg_Margin_Pct,
    ROUND(SUM(Operating_Cost_GBP)/SUM(Revenue_GBP)*100, 1) AS Cost_Income_Ratio,
    ROUND(SUM(Is_Digital)*100.0/COUNT(*), 1)        AS Digital_Adoption_Pct,
    ROUND(AVG(Credit_Score), 0)                     AS Avg_Customer_Credit_Score,
    SUM(Is_Flagged)                                 AS Flagged_Transactions,
    ROUND(SUM(Is_Flagged)*100.0/COUNT(*), 1)        AS Flag_Rate_Pct,
    ROUND(SUM(CASE WHEN Status='Completed'
                   THEN 1 ELSE 0 END)*100.0/COUNT(*), 1) AS Completion_Rate_Pct
FROM banking_transactions
GROUP BY Bank
ORDER BY Net_Revenue_GBPk DESC;

-- ── QUERY 8: Year-over-Year Growth by Bank ───────────────
WITH yearly AS (
    SELECT
        Bank,
        Year,
        SUM(Revenue_GBP)            AS Revenue
    FROM banking_transactions
    GROUP BY Bank, Year
)
SELECT
    curr.Bank,
    curr.Year,
    ROUND(curr.Revenue, 0)          AS Revenue_GBP,
    ROUND(prev.Revenue, 0)          AS Prior_Year_Revenue,
    ROUND((curr.Revenue - prev.Revenue)
          / prev.Revenue * 100, 1)  AS YoY_Growth_Pct
FROM yearly curr
LEFT JOIN yearly prev
    ON curr.Bank = prev.Bank
    AND curr.Year = prev.Year + 1
ORDER BY curr.Bank, curr.Year;

-- ── QUERY 9: Product Mix by Customer Segment ─────────────
SELECT
    Segment,
    Product,
    COUNT(*)                                        AS Transactions,
    ROUND(SUM(Revenue_GBP), 0)                      AS Revenue_GBP,
    ROUND(AVG(Transaction_Value_GBP), 0)            AS Avg_Value,
    ROUND(AVG(Credit_Score), 0)                     AS Avg_Credit_Score
FROM banking_transactions
GROUP BY Segment, Product
ORDER BY Segment, Revenue_GBP DESC;

-- ── QUERY 10: Monthly Revenue Run Rate ───────────────────
-- Purpose: Identify seasonal trends and revenue patterns
SELECT
    Month_Name,
    Year,
    COUNT(*)                                        AS Transactions,
    ROUND(SUM(Revenue_GBP), 0)                      AS Monthly_Revenue,
    ROUND(AVG(SUM(Revenue_GBP)) OVER
          (PARTITION BY Year ORDER BY
           MIN(Date) ROWS BETWEEN 2 PRECEDING
           AND CURRENT ROW), 0)                     AS Rolling_3M_Avg_Revenue
FROM banking_transactions
GROUP BY Month_Name, Year, Month_Year
ORDER BY Year, MIN(Date);
