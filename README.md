# UK Banking Analytics Dashboard - Python · SQL · Power BI


> End-to-end banking analytics project analysing **5,000 UK banking transactions** across 5 major banks (HSBC, Barclays, Lloyds, NatWest, Santander UK) from 2022–2024. Built using a full data pipeline: Python for analysis → SQL for querying → Power BI for interactive dashboard.

---

## Dashboard Preview

![UK Banking Analytics Dashboard](https://github.com/shardik-solanki/UK-Banking-Analytics-Dashboard/blob/4015fcdbdff4789f59e9f1dd15a4aed0e94ec42a/UK%20Banking%20Analytics%20Dashboard.png)

---

## Business Problem

Banking risk and performance teams need to monitor revenue performance, identify high-risk transactions, understand product profitability, and track regional trends - all in real time. This project simulates that analytical workflow end-to-end across a 5,000-row transaction dataset.

---

## Key Findings

| Metric | Value | Insight |
|---|---|---|
| Total Transactions | 5,000 | Jan 2022 – Dec 2024 |
| Total Revenue | £11.72M | Across all 5 banks |
| Net Revenue | £5.08M | After operating costs |
| Avg Portfolio Margin | 4.15% | Weighted average |
| Flagged Transactions | 259 (5.2%) | Require compliance review |
| HSBC Market Share | 25.6% | Highest of all 5 banks |
| Top Product | Business Loan | £6.1M  52% of revenue |
| Digital Adoption | 38.9% | Key growth opportunity |
| Top Region | Bristol | £1.34M revenue |

---

## Bank Performance Scorecard

| Bank | Revenue | Net Revenue | Margin % | CIR % | Flagged |
|---|---|---|---|---|---|
| HSBC | £3.00M | £1.50M | 4.33% | 50.2% | 67 |
| Barclays | £2.70M | £1.08M | 4.04% | 60.1% | 46 |
| Lloyds | £2.26M | £0.91M | 4.26% | 59.6% | 50 |
| NatWest | £2.06M | £0.89M | 4.18% | 56.9% | 44 |
| Santander UK | £1.70M | £0.70M | 3.80% | 58.5% | 52 |

**Key insight:** HSBC leads on both scale and efficiency  lowest Cost-to-Income ratio at 50.2% vs industry average of 57.1%.

---

## Dashboard Features

- **5 KPI Cards**  Total Transactions, Revenue, Net Revenue, Avg Margin, Flagged Count
- **Revenue by Bank**  Horizontal bar chart with bank-specific colours
- **Quarterly Revenue Trend**  Monthly granularity bar + line chart (Jan 2022 – Dec 2024)
- **Risk Portfolio Donut**  Low/Medium/High risk split with colour coding
- **Revenue by Product** - 8 product types ranked by revenue
- **Bank Scorecard Table** - Full KPI comparison with conditional formatting
- **Revenue by Region** - Top 5 UK cities
- **Dynamic Slicers** - Filter by Bank and Year - all visuals update together
- **Insight Text Box** - Analyst narrative summarising key findings

---

## Tools & Technology

| Tool | Purpose |
|---|---|
| Python (pandas) | Data analysis, KPI calculation, summary table export |
| SQL (10 queries) | Revenue analysis, YoY growth, risk profiling, trend analysis |
| Power BI (DAX) | Interactive dashboard, conditional formatting, slicers |
| CSV | Data storage and inter-tool data transfer |

---

## Project Structure

```
uk-banking-analytics-dashboard/
├── UK Banking Analytics Dashboard.png       ← Dashboard screenshot
├── UK Banking Analytics.pbix                ← Power BI file
├── UK Banking Transactions.csv              ← Raw dataset (5,000 rows)
├── UK Banking Monthly Summary.csv           ← Python-generated summary
├── UK Banking Product Summary.csv           ← Product analysis output
├── UK Banking Risk Summary.csv              ← Risk analysis output
├── Python Analysis Script.py                ← Full Python analysis
└── SQL Banking Queries.sql                  ← 10 SQL queries
```

---

## Data Dictionary

| Column | Description |
|---|---|
| Transaction_ID | Unique transaction identifier |
| Date / Year / Quarter | Transaction timing |
| Bank | One of 5 UK banks |
| Region | One of 10 UK cities |
| Product | One of 8 banking products |
| Segment | Retail / Commercial / Wealth / Private |
| Channel | Branch / Online / Mobile / Phone / ATM |
| Transaction_Value_GBP | Transaction amount in GBP |
| Margin_Pct | Revenue margin percentage |
| Revenue_GBP | Revenue generated from transaction |
| Operating_Cost_GBP | Cost allocated to transaction |
| Net_Revenue_GBP | Revenue minus operating cost |
| Risk_Rating | Low / Medium / High |
| Credit_Score | Customer credit score (300–850) |
| Is_Digital | 1 = Digital channel, 0 = Traditional |
| Is_Flagged | 1 = Compliance flagged, 0 = Clean |

---

## How to Run

**Python analysis:**
```bash
pip install pandas numpy
python Python Analysis Script.py
```

**SQL queries:**
```bash
# Import CSV into DB Browser for SQLite (free)
# Run SQL Banking Queries.sql
```

**Power BI dashboard:**
```
1. Open Power BI Desktop
2. Get Data → CSV → import all 4 CSV files
3. Open UK Banking Analytics.pbix
```

---

## SQL Query Examples

```sql
-- Bank Performance Scorecard
SELECT
    Bank,
    COUNT(*)                    AS Total_Transactions,
    ROUND(SUM(Revenue_GBP),0)   AS Total_Revenue,
    ROUND(AVG(Margin_Pct),2)    AS Avg_Margin_Pct,
    SUM(Is_Flagged)             AS Flagged_Count
FROM banking_transactions
GROUP BY Bank
ORDER BY Total_Revenue DESC;
```

---

## Skills Demonstrated

- End-to-end data pipeline (raw data → analysis → dashboard)
- Python data analysis with pandas (aggregation, KPI calculation, CSV export)
- SQL querying (window functions, CTEs, YoY growth, rolling averages)
- Power BI dashboard design (DAX, slicers, conditional formatting)
- Financial analysis (revenue, margin, cost-to-income, risk rating)
- Banking domain knowledge (products, segments, compliance, CIR)

---

## About

Built by **Hardik Solanki** - Finance & Data Analyst with 3+ years experience in financial reporting, FP&A, and data analytics.

- LinkedIn: [linkedin.com/in/hardiksolanki](https://www.linkedin.com/in/hardikkumarsolanki/)
- GitHub: [github.com/shardik-solanki](https://github.com/shardik-solanki)
- Email: hardiksolanki.uk@gmail.com

*Part of a finance analytics portfolio targeting FP&A Analyst and Financial Analyst roles in UK financial services.*
