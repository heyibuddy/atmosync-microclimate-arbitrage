import os
from dotenv import load_dotenv
import snowflake.connector

load_dotenv()


def get_connection():
    return snowflake.connector.connect(
        user=os.environ["SNOWFLAKE_USER"],
        password=os.environ["SNOWFLAKE_PASSWORD"],
        account=os.environ["SNOWFLAKE_ACCOUNT"],
        warehouse=os.getenv("SNOWFLAKE_WAREHOUSE", "COMPUTE_WH"),
        database=os.getenv("SNOWFLAKE_DATABASE", "ATMOSYNC_DB"),
        schema=os.getenv("SNOWFLAKE_SCHEMA", "ANALYTICS"),
    )


def evaluate_critical_shipments():
    sql = """
        SELECT
            container_id,
            market_name,
            risk_status,
            projected_revenue_usd,
            estimated_hours_left,
            transit_hours_needed
        FROM MART_SPOILAGE_ARBITRAGE
        WHERE risk_status = 'CRITICAL: High Spoilage Hazard'
        ORDER BY projected_revenue_usd DESC
    """

    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute(sql)
            rows = cursor.fetchall()

        if not rows:
            print("No critical shipments detected.")
            return

        for container_id, market, status, revenue, hours_left, transit_hours in rows:
            print(
                f"ALERT | {container_id} | {market} | {status} | "
                f"Projected revenue: ${revenue:,.2f} | "
                f"Hours left: {hours_left:.2f} | Transit: {transit_hours:.2f}"
            )
    finally:
        conn.close()


if __name__ == "__main__":
    try:
        evaluate_critical_shipments()
    except KeyError as exc:
        raise SystemExit(f"Missing environment variable: {exc}")
