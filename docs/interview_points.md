# Interview Talking Points

## 30-second explanation

"AtmoSync is an end-to-end streaming analytics project for agricultural container logistics. I simulated IoT telemetry in Python, streamed events through Kafka, stored raw JSON in Snowflake, transformed it with dbt, and built a spoilage-arbitrage model that compares estimated shelf-life with route transit time and market value. The final BI layer highlights risky containers and potential rerouting actions."

## Technologies

- Python
- Apache Kafka
- Snowflake
- dbt Core
- SQL
- Apache Superset
- Docker

## Data Analyst angle

- KPI design
- SQL transformations
- Risk segmentation
- Route and revenue analysis
- Dashboard design
- Alert logic
- Data quality validation

## Data Engineer angle

- Event generation
- Streaming ingestion
- Raw/analytics schemas
- ELT architecture
- dbt modeling
- Warehouse optimization
- Monitoring

## Important caveat

The spoilage formula and market prices are synthetic assumptions for portfolio demonstration. In a real deployment, the degradation model would need domain validation and calibrated agricultural/scientific data.
