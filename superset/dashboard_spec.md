# AtmoSync Superset Dashboard Specification

## Dashboard title

**AtmoSync — Micro-Climate Arbitrage Control Tower**

## KPI row

1. Active Containers
2. Critical Containers
3. Warning Containers
4. Potential Revenue
5. Average Temperature

## Main charts

### 1. Container Risk Matrix
- Dimension: `container_id`
- Group by: `risk_status`
- Metric: count

### 2. Temperature Monitor
- X axis: `recorded_at`
- Y axis: `temperature_celsius`
- Dimension: `container_id`

### 3. Route Economics
- X axis: `market_name`
- Metric: `projected_revenue_usd`
- Secondary metric: `transit_hours_needed`

### 4. Executive Action Table

Columns:
- `container_id`
- `market_name`
- `temperature_celsius`
- `humidity_percentage`
- `estimated_hours_left`
- `transit_hours_needed`
- `projected_revenue_usd`
- `risk_status`
- `recommended_action`

Sort by:
1. Critical risk
2. Projected revenue descending

### 5. Map

Use:
- Latitude: `latitude`
- Longitude: `longitude`
- Group: `container_id`
- Metric: `temperature_celsius`

## Suggested filters

- Container
- Commodity
- Risk status
- Market
- Recorded time

## Business story

The dashboard should answer three questions:

1. Which containers are deteriorating?
2. Which destinations can still be reached inside the estimated shelf-life window?
3. Where is there a financially meaningful rerouting opportunity?
