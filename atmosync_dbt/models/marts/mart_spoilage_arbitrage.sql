{{ config(materialized='table') }}

WITH latest_telemetry AS (
    SELECT *
    FROM (
        SELECT
            t.*,
            ROW_NUMBER() OVER (
                PARTITION BY container_id
                ORDER BY recorded_at DESC, ingested_at DESC
            ) AS rn
        FROM {{ ref('stg_iot_telemetry') }} t
    )
    WHERE rn = 1
),

telemetry_risk AS (
    SELECT
        *,
        /*
        Synthetic portfolio assumption:
        lower temperature + higher humidity = slower deterioration.
        This is NOT a food-safety model.
        */
        CASE
            WHEN temperature_celsius > 10 THEN 8.0
            WHEN temperature_celsius > 8 THEN 18.0
            WHEN temperature_celsius > 6 THEN 36.0
            ELSE 60.0
        END
        *
        CASE
            WHEN humidity_percentage >= 90 THEN 0.70
            WHEN humidity_percentage >= 80 THEN 0.85
            ELSE 1.00
        END AS estimated_hours_left
    FROM latest_telemetry
),

market_calculations AS (
    SELECT
        t.container_id,
        t.commodity,
        t.temperature_celsius,
        t.humidity_percentage,
        t.vibration_g,
        t.recorded_at,
        t.latitude,
        t.longitude,
        t.estimated_hours_left,
        m.market_id,
        m.market_name,
        m.distance_km,
        m.base_price_per_kg,
        (m.distance_km / 60.0) AS transit_hours_needed,

        CASE
            WHEN (m.distance_km / 60.0) <= t.estimated_hours_left
                THEN m.base_price_per_kg * 1000
            ELSE 0.00
        END AS projected_revenue_usd
    FROM telemetry_risk t
    INNER JOIN {{ ref('stg_market_pricing') }} m
        ON t.commodity = m.commodity
)

SELECT
    *,
    CASE
        WHEN transit_hours_needed > estimated_hours_left
            THEN 'CRITICAL: High Spoilage Hazard'
        WHEN transit_hours_needed >= estimated_hours_left - 4
            THEN 'WARNING: Narrow Execution Window'
        ELSE 'OPTIMAL: Safe Route'
    END AS risk_status,

    CASE
        WHEN transit_hours_needed > estimated_hours_left
            THEN 'REROUTE'
        WHEN transit_hours_needed >= estimated_hours_left - 4
            THEN 'MONITOR'
        ELSE 'CONTINUE'
    END AS recommended_action

FROM market_calculations
