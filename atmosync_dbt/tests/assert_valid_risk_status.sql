SELECT *
FROM {{ ref('mart_spoilage_arbitrage') }}
WHERE risk_status NOT IN (
    'CRITICAL: High Spoilage Hazard',
    'WARNING: Narrow Execution Window',
    'OPTIMAL: Safe Route'
)
