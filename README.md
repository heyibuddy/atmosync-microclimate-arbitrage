# AtmoSync — Micro-Climate Arbitrage Analytics

An end-to-end data engineering + analytics portfolio project that simulates IoT container telemetry, streams events through Apache Kafka, lands raw JSON in Snowflake, transforms data with dbt Core, calculates spoilage/route risk, and exposes an executive BI layer for rerouting decisions.

## Architecture

```text
Python IoT Simulator
        |
        v
Apache Kafka  --->  Snowflake RAW
                         |
                         v
                    dbt Core
                staging -> marts
                         |
                         v
             Spoilage Arbitrage Mart
                         |
                         v
                  Apache Superset
                         |
                         v
             Risk / Revenue Dashboard
```

## Repository

```text
atmosync-microclimate-arbitrage/
├── README.md
├── .gitignore
├── .env.example
├── docker-compose.yml
├── requirements.txt
├── simulation/
│   ├── __init__.py
│   ├── iot_simulator.py
│   └── alert_system.py
├── snowflake/
│   └── setup_queries.sql
├── atmosync_dbt/
│   ├── dbt_project.yml
│   ├── profiles.yml.example
│   ├── models/
│   │   ├── sources.yml
│   │   ├── staging/
│   │   │   ├── stg_iot_telemetry.sql
│   │   │   └── stg_market_pricing.sql
│   │   └── marts/
│   │       └── mart_spoilage_arbitrage.sql
│   └── tests/
│       └── assert_valid_risk_status.sql
├── data/
│   └── sample_market_pricing.csv
└── superset/
    └── dashboard_spec.md
```

## Quick start — simulation only

This mode needs only Python and is useful for demonstrating the project locally.

```bash
python -m venv .venv
# Windows:
.venv\Scripts\activate
# macOS/Linux:
source .venv/bin/activate

pip install -r requirements.txt
python simulation/iot_simulator.py --count 20 --interval 0.2 --output data/telemetry_sample.jsonl
```

The simulator deliberately injects occasional temperature/humidity deterioration so the dashboard logic has meaningful risk cases.

## Kafka mode

Start Kafka locally:

```bash
docker compose up -d kafka
```

Then:

```bash
python simulation/iot_simulator.py --kafka --count 100 --interval 0.5
```

The default Kafka broker is `localhost:9092` and topic is `container_telemetry`.

## Snowflake setup

1. Open Snowflake.
2. Run `snowflake/setup_queries.sql`.
3. Create a Snowflake connection for dbt.
4. Copy `atmosync_dbt/profiles.yml.example` to your dbt profiles location as `profiles.yml`.
5. Configure credentials using environment variables rather than hard-coding passwords.
6. From `atmosync_dbt/`, run:

```bash
dbt debug
dbt run
dbt test
```

## Superset

Use the Snowflake connection and add:

```text
ATMOSYNC_DB.ANALYTICS.MART_SPOILAGE_ARBITRAGE
```

Recommended dashboard charts:

- Current container temperature
- Containers by risk status
- Recommended market by projected revenue
- Transit hours vs estimated hours remaining
- Temperature and humidity over time
- At-risk container table
- Potential revenue recovery

See `superset/dashboard_spec.md` for the suggested dashboard layout.

## Alerting

Configure Snowflake credentials through environment variables:

```text
SNOWFLAKE_USER
SNOWFLAKE_PASSWORD
SNOWFLAKE_ACCOUNT
SNOWFLAKE_WAREHOUSE
SNOWFLAKE_DATABASE
SNOWFLAKE_SCHEMA
```

Then:

```bash
python simulation/alert_system.py
```

The alert script queries critical shipments and prints actionable reroute signals.

## Portfolio description

**AtmoSync: Micro-Climate Arbitrage Analytics** uses streaming IoT telemetry, cloud warehousing, SQL transformation and BI visualization to identify when environmental deterioration may make the original destination economically unattractive. The system compares estimated shelf-life against route transit time and market price, producing a risk status and projected revenue opportunity.

> This is a portfolio simulation. The spoilage equations, market prices, route speeds and sensor values are synthetic assumptions, not a production food-safety model.

## Working BI Dashboard

Open `dashboard/AtmoSync_Dashboard.html` for the interactive dashboard. Use `dashboard/AtmoSync_PowerBI_Dataset.xlsx` for Power BI. See the dashboard build and GitHub guides.
