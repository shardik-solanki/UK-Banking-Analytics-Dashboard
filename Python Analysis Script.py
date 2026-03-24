import pandas as pd
import numpy as np

# ── LOAD DATA ──────────────────────────────────────────
df = pd.read_csv('UK_Banking_Transactions_5000.csv')
df['Date'] = pd.to_datetime(df['Date'])

print("=" * 60)
print("UK BANKING TRANSACTIONS — PYTHON ANALYSIS")
print("=" * 60)
print(f"\nDataset: {len(df):,} transactions | {df['Date'].min().date()} to {df['Date'].max().date()}")
print(f"Banks: {', '.join(df['Bank'].unique())}")
print(f"Products: {len(df['Product'].unique())} types")
print(f"Regions: {len(df['Region'].unique())} UK regions")

# ── ANALYSIS 1: Revenue by Bank ───────────────────────
print("\n" + "─" * 60)
print("1. REVENUE PERFORMANCE BY BANK")
print("─" * 60)
bank_rev = df.groupby('Bank').agg(
    Transactions=('Transaction_ID','count'),
    Total_Revenue=('Revenue_GBP','sum'),
    Avg_Revenue=('Revenue_GBP','mean'),
    Total_Net_Revenue=('Net_Revenue_GBP','sum'),
    Avg_Margin=('Margin_Pct','mean')
).round(2).sort_values('Total_Revenue', ascending=False)

bank_rev['Market_Share_Pct'] = (bank_rev['Total_Revenue'] / bank_rev['Total_Revenue'].sum() * 100).round(1)
print(bank_rev.to_string())

# ── ANALYSIS 2: Revenue by Product ────────────────────
print("\n" + "─" * 60)
print("2. MOST PROFITABLE PRODUCTS")
print("─" * 60)
prod_rev = df.groupby('Product').agg(
    Count=('Transaction_ID','count'),
    Total_Revenue=('Revenue_GBP','sum'),
    Avg_Transaction_Value=('Transaction_Value_GBP','mean'),
    Avg_Margin_Pct=('Margin_Pct','mean')
).round(2).sort_values('Total_Revenue', ascending=False)
print(prod_rev.to_string())

# ── ANALYSIS 3: Digital vs Branch ─────────────────────
print("\n" + "─" * 60)
print("3. DIGITAL vs TRADITIONAL CHANNEL ANALYSIS")
print("─" * 60)
digital = df.groupby('Is_Digital').agg(
    Count=('Transaction_ID','count'),
    Total_Revenue=('Revenue_GBP','sum'),
    Avg_Value=('Transaction_Value_GBP','mean')
).round(2)
digital.index = ['Traditional (Branch/Phone/ATM)', 'Digital (Online/Mobile)']
print(digital.to_string())
digital_pct = df['Is_Digital'].mean() * 100
print(f"\nDigital adoption rate: {digital_pct:.1f}%")

# ── ANALYSIS 4: Risk Analysis ──────────────────────────
print("\n" + "─" * 60)
print("4. RISK RATING ANALYSIS")
print("─" * 60)
risk = df.groupby('Risk_Rating').agg(
    Count=('Transaction_ID','count'),
    Total_Value=('Transaction_Value_GBP','sum'),
    Flagged_Count=('Is_Flagged','sum'),
    Avg_Credit_Score=('Credit_Score','mean')
).round(2)
risk['Pct_of_Portfolio'] = (risk['Count'] / len(df) * 100).round(1)
print(risk.to_string())

# ── ANALYSIS 5: Quarterly Trend ───────────────────────
print("\n" + "─" * 60)
print("5. QUARTERLY REVENUE TREND")
print("─" * 60)
qtr = df.groupby(['Year','Quarter']).agg(
    Transactions=('Transaction_ID','count'),
    Revenue=('Revenue_GBP','sum'),
    Net_Revenue=('Net_Revenue_GBP','sum')
).round(2)
print(qtr.to_string())

# ── ANALYSIS 6: Regional Performance ─────────────────
print("\n" + "─" * 60)
print("6. TOP REGIONS BY REVENUE")
print("─" * 60)
region = df.groupby('Region').agg(
    Count=('Transaction_ID','count'),
    Revenue=('Revenue_GBP','sum'),
    Avg_Transaction=('Transaction_Value_GBP','mean')
).round(2).sort_values('Revenue', ascending=False)
print(region.to_string())

# ── ANALYSIS 7: KPI Summary ───────────────────────────
print("\n" + "─" * 60)
print("7. KEY PERFORMANCE INDICATORS — PORTFOLIO SUMMARY")
print("─" * 60)
total_rev = df['Revenue_GBP'].sum()
total_net = df['Net_Revenue_GBP'].sum()
total_val = df['Transaction_Value_GBP'].sum()
flagged = df['Is_Flagged'].sum()
completed = (df['Status']=='Completed').sum()

print(f"Total Transaction Value:  £{total_val:>15,.0f}")
print(f"Total Revenue Generated:  £{total_rev:>15,.0f}")
print(f"Total Net Revenue:        £{total_net:>15,.0f}")
print(f"Overall Margin:            {total_rev/total_val*100:>14.2f}%")
print(f"Portfolio Net Margin:      {total_net/total_rev*100:>14.2f}%")
print(f"Completed Transactions:    {completed:>14,} ({completed/len(df)*100:.1f}%)")
print(f"Flagged Transactions:      {flagged:>14,} ({flagged/len(df)*100:.1f}%)")
print(f"Digital Transaction Rate:  {digital_pct:>14.1f}%")
print(f"Avg Credit Score:          {df['Credit_Score'].mean():>14.0f}")

# ── EXPORT SUMMARY TABLES FOR POWER BI ────────────────
print("\n" + "─" * 60)
print("EXPORTING SUMMARY TABLES FOR POWER BI")
print("─" * 60)

# Monthly summary
monthly = df.groupby(['Year','Month_Year','Bank']).agg(
    Transactions=('Transaction_ID','count'),
    Revenue=('Revenue_GBP','sum'),
    Net_Revenue=('Net_Revenue_GBP','sum'),
    Avg_Margin=('Margin_Pct','mean'),
    Digital_Pct=('Is_Digital','mean'),
    Flagged_Count=('Is_Flagged','sum')
).round(2).reset_index()
monthly['Digital_Pct'] = (monthly['Digital_Pct']*100).round(1)
monthly.to_csv('UK_Banking_Monthly_Summary.csv', index=False)
print(f"Monthly summary: {len(monthly)} rows → UK_Banking_Monthly_Summary.csv")

# Product summary
product_summary = df.groupby(['Year','Product','Bank']).agg(
    Count=('Transaction_ID','count'),
    Revenue=('Revenue_GBP','sum'),
    Avg_Value=('Transaction_Value_GBP','mean'),
    Avg_Margin=('Margin_Pct','mean')
).round(2).reset_index()
product_summary.to_csv('UK_Banking_Product_Summary.csv', index=False)
print(f"Product summary: {len(product_summary)} rows → UK_Banking_Product_Summary.csv")

# Risk summary
risk_summary = df.groupby(['Bank','Risk_Rating','Product']).agg(
    Count=('Transaction_ID','count'),
    Total_Value=('Transaction_Value_GBP','sum'),
    Flagged=('Is_Flagged','sum'),
    Avg_Credit_Score=('Credit_Score','mean')
).round(2).reset_index()
risk_summary.to_csv('UK_Banking_Risk_Summary.csv', index=False)
print(f"Risk summary: {len(risk_summary)} rows → UK_Banking_Risk_Summary.csv")

print("\n✅ All files exported successfully!")
print("Import all CSV files into Power BI for the full dashboard.")
