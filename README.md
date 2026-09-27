# 🌦️ AtmoSync — Micro-Climate Arbitrage Analytics

An end-to-end data engineering + analytics portfolio project that simulates IoT container telemetry, streams events through Apache Kafka, lands raw JSON in Snowflake, transforms data with dbt Core, calculates spoilage and route risk, and exposes an executive BI layer for rerouting and revenue decisions.

---

## 📌 Project Overview

AtmoSync simulates a smart cold-chain logistics environment where containers continuously generate environmental telemetry.

The system combines:

- 🌡️ Temperature
- 💧 Humidity
- 📳 Vibration
- 📍 GPS location
- 💰 Market pricing
- 🚚 Route transit time

The analytics layer compares estimated remaining shelf-life with route transit time and market pricing to identify potential shipment risks and revenue opportunities.

---

## 🏗️ Architecture

```text
Python IoT Simulator
        |
        v
Apache Kafka
        |
        v
Snowflake RAW
        |
        v
      dbt Core
   staging → marts
        |
        v
Spoilage Arbitrage Mart
        |
        +------------------+
        |                  |
        v                  v
 Apache Superset       Power BI
        |                  |
        +--------+---------+
                 |
                 v
       Risk / Revenue Dashboard
🛠️ Technology Stack
Technology	Purpose
Python	IoT simulation and automation
Apache Kafka	Real-time event streaming
Snowflake	Cloud data warehouse
dbt Core	Data transformation and testing
SQL	Analytics and data modeling
Power BI	Business intelligence dashboard
Apache Superset	Analytics visualization
Docker	Kafka environment
Git & GitHub	Version control

🎯 Business Problem

Cold-chain shipments can experience environmental deterioration during transportation.

AtmoSync demonstrates how telemetry and market data can be combined to answer:

Which shipment is at risk, how much estimated time remains, and which destination market may provide a better economic opportunity?

The project generates a risk status and projected revenue opportunity based on synthetic shipment conditions, route assumptions, and market prices.

📊 Key Analytics

The project analyzes:

Container temperature trends
Humidity conditions
Environmental deterioration
Estimated remaining shelf-life
Route transit time
Market price differences
Shipment risk classification
Projected revenue opportunity
Recommended destination market
At-risk shipment alerts
Risk Classification
Risk Status	Meaning
🟢 SAFE	Shipment conditions provide sufficient execution window
🟡 WARNING	Narrow execution window
🔴 CRITICAL	High spoilage hazard
📈 Working BI Dashboard

The project includes an interactive browser-based dashboard and Power BI-ready dataset.

Executive Dashboard

Revenue Opportunity

Temperature Monitoring

Dashboard Files
dashboard/
├── AtmoSync_Dashboard.html
├── AtmoSync_PowerBI_Dataset.xlsx
├── POWERBI_SUPERSET_BUILD_GUIDE.md
├── GITHUB_UPLOAD_STEPS.md
└── screenshots

Open the interactive dashboard:

dashboard/AtmoSync_Dashboard.html

The Excel dataset can be loaded into Power BI for dashboard development.

📂 Repository Structure
atmosync-microclimate-arbitrage/
│
├── README.md
├── .gitignore
├── .env.example
├── docker-compose.yml
├── requirements.txt
│
├── simulation/
│   ├── __init__.py
│   ├── iot_simulator.py
│   └── alert_system.py
│
├── snowflake/
│   └── setup_queries.sql
│
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
│
├── data/
│   ├── powerbi_telemetry.csv
│   ├── powerbi_market_pricing.csv
│   ├── powerbi_spoilage_arbitrage.csv
│   ├── powerbi_current_container_status.csv
│   └── sample_market_pricing.csv
│
├── dashboard/
│   ├── AtmoSync_Dashboard.html
│   ├── AtmoSync_PowerBI_Dataset.xlsx
│   ├── POWERBI_SUPERSET_BUILD_GUIDE.md
│   ├── GITHUB_UPLOAD_STEPS.md
│   ├── screenshot_01_executive_dashboard.png
│   ├── screenshot_02_revenue_opportunity.png
│   └── screenshot_03_temperature_monitor.png
│
├── docs/
│   ├── interview_points.md
│   └── weekly_updates.md
│
└── superset/
    └── dashboard_spec.md
🚀 Quick Start — Simulation Only

Create a Python virtual environment:

python -m venv .venv
Windows
.venv\Scripts\activate
macOS/Linux
source .venv/bin/activate

Install dependencies:

pip install -r requirements.txt

Run the IoT simulator:

python simulation/iot_simulator.py --count 20 --interval 0.2 --output data/telemetry_sample.jsonl

The simulator deliberately injects occasional temperature/humidity deterioration so that the analytics pipeline contains meaningful risk scenarios.

⚡ Kafka Mode

Start Kafka locally:

docker compose up -d kafka

Then run:

python simulation/iot_simulator.py --kafka --count 100 --interval 0.5

Default Kafka configuration:

Broker: localhost:9092
Topic: container_telemetry
❄️ Snowflake Setup
Open Snowflake.
Run:
snowflake/setup_queries.sql
Create a Snowflake connection for dbt.
Copy:
atmosync_dbt/profiles.yml.example

to your dbt profiles location as:

profiles.yml
Configure credentials using environment variables.

From the atmosync_dbt/ directory:

dbt debug
dbt run
dbt test
📊 Superset

Use the Snowflake analytics mart:

ATMOSYNC_DB.ANALYTICS.MART_SPOILAGE_ARBITRAGE

Recommended dashboard charts:

Current container temperature
Containers by risk status
Recommended market by projected revenue
Transit hours vs estimated hours remaining
Temperature and humidity over time
At-risk container table
Potential revenue recovery

See:

superset/dashboard_spec.md

for the dashboard layout.

🚨 Alerting

Configure Snowflake credentials through environment variables:

SNOWFLAKE_USER
SNOWFLAKE_PASSWORD
SNOWFLAKE_ACCOUNT
SNOWFLAKE_WAREHOUSE
SNOWFLAKE_DATABASE
SNOWFLAKE_SCHEMA

Run:

python simulation/alert_system.py

The alert script queries critical shipments and prints actionable reroute signals.

💡 Portfolio Value

This project demonstrates practical experience with:

SQL analytics
Python
Data cleaning and transformation
Data modeling
dbt
Snowflake
Kafka
Power BI
Apache Superset
Data visualization
Business intelligence
Git/GitHub
End-to-end analytics pipeline design
📌 Project Highlights
Data Engineering

Built a simulated pipeline from IoT event generation through Kafka, Snowflake and dbt.

Data Analytics

Created analytics models to estimate shipment risk, remaining execution time and revenue opportunities.

Business Intelligence

Developed an executive dashboard for monitoring shipment conditions, risk and potential revenue recovery.

Automation

Added an alerting script that identifies critical shipments requiring attention.

⚠️ Disclaimer

This is a portfolio simulation.

The IoT telemetry, market prices, route speeds and spoilage equations are synthetic assumptions created for demonstration purposes.

The spoilage calculations are not intended to represent a real food-safety, regulatory or operational model.

👨‍💻 Author

Abhishek Tanwar

Data Analyst | SQL | Power BI | Excel | Python
