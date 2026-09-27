{{ config(materialized='view') }}

SELECT
    market_id,
    market_name,
    commodity,
    base_price_per_kg,
    distance_km,
    updated_at
FROM {{ source('raw_sources', 'market_pricing') }}
WHERE base_price_per_kg > 0
  AND distance_km >= 0
