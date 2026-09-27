{{ config(materialized='view') }}

WITH raw_data AS (
    SELECT
        raw_payload:container_id::VARCHAR AS container_id,
        raw_payload:commodity::VARCHAR AS commodity,
        raw_payload:temperature_celsius::FLOAT AS temperature_celsius,
        raw_payload:humidity_percentage::FLOAT AS humidity_percentage,
        raw_payload:vibration_g::FLOAT AS vibration_g,
        raw_payload:timestamp::TIMESTAMP_TZ AS recorded_at,
        raw_payload:latitude::FLOAT AS latitude,
        raw_payload:longitude::FLOAT AS longitude,
        ingested_at
    FROM {{ source('raw_sources', 'iot_telemetry') }}
)

SELECT
    container_id,
    commodity,
    temperature_celsius,
    humidity_percentage,
    vibration_g,
    recorded_at,
    latitude,
    longitude,
    ingested_at
FROM raw_data
WHERE container_id IS NOT NULL
  AND commodity IS NOT NULL
  AND temperature_celsius IS NOT NULL
  AND humidity_percentage IS NOT NULL
