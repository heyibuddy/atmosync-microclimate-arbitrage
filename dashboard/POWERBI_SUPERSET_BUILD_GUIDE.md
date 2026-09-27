# AtmoSync — Power BI / Superset Dashboard

Open `AtmoSync_Dashboard.html` in Chrome/Edge for the working interactive browser dashboard.

## Power BI
Import `AtmoSync_PowerBI_Dataset.xlsx`.

DAX:
```DAX
Active Containers = DISTINCTCOUNT(Current_Status[container_id])

Critical Containers =
CALCULATE(
    DISTINCTCOUNT(Current_Status[container_id]),
    Current_Status[risk_status] = "CRITICAL: High Spoilage Hazard"
)

Warning Containers =
CALCULATE(
    DISTINCTCOUNT(Current_Status[container_id]),
    Current_Status[risk_status] = "WARNING: Narrow Execution Window"
)

Projected Revenue = SUM(Current_Status[projected_revenue_usd])

Average Temperature = AVERAGE(Current_Status[temperature_celsius])
```

Page layout: KPI cards → risk distribution + revenue by market → temperature trend + route economics table.

## Superset
Connect to `ATMOSYNC_DB.ANALYTICS.MART_SPOILAGE_ARBITRAGE`.

Use Big Number, Bar Chart, Time-series and Table visualizations for the same KPIs.

All prices and spoilage assumptions are synthetic portfolio data.
