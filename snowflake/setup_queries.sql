-- AtmoSync Snowflake environment
CREATE DATABASE IF NOT EXISTS ATMOSYNC_DB;

CREATE SCHEMA IF NOT EXISTS ATMOSYNC_DB.RAW;
CREATE SCHEMA IF NOT EXISTS ATMOSYNC_DB.ANALYTICS;

CREATE OR REPLACE TABLE ATMOSYNC_DB.RAW.IOT_TELEMETRY (
    raw_payload VARIANT NOT NULL,
    ingested_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE ATMOSYNC_DB.RAW.MARKET_PRICING (
    market_id VARCHAR NOT NULL,
    market_name VARCHAR NOT NULL,
    commodity VARCHAR NOT NULL,
    base_price_per_kg NUMBER(10,2) NOT NULL,
    distance_km NUMBER(10,2) NOT NULL,
    updated_at TIMESTAMP_NTZ NOT NULL
);

INSERT INTO ATMOSYNC_DB.RAW.MARKET_PRICING
    (market_id, market_name, commodity, base_price_per_kg, distance_km, updated_at)
VALUES
    ('MKT-01', 'Primary Market (Target Longhaul)', 'Avocado', 5.50, 800.00, CURRENT_TIMESTAMP()),
    ('MKT-02', 'Secondary Market (Reroute Close)', 'Avocado', 4.80, 200.00, CURRENT_TIMESTAMP()),
    ('MKT-03', 'Tertiary Market (Reroute Midhaul)', 'Avocado', 4.20, 450.00, CURRENT_TIMESTAMP());

-- Optional Snowpipe Streaming / Kafka ingestion can land JSON into IOT_TELEMETRY.
-- Example manual validation:
SELECT * FROM ATMOSYNC_DB.RAW.IOT_TELEMETRY LIMIT 20;

-- Query-performance optimization for time-series access.
ALTER TABLE ATMOSYNC_DB.RAW.IOT_TELEMETRY
    CLUSTER BY (ingested_at);
