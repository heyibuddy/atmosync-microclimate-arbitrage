import argparse
import json
import os
import random
import time
from datetime import datetime, timezone
from pathlib import Path

try:
    from kafka import KafkaProducer
except ImportError:
    KafkaProducer = None


DEFAULT_BROKER = os.getenv("KAFKA_BOOTSTRAP_SERVERS", "localhost:9092")
DEFAULT_TOPIC = os.getenv("KAFKA_TOPIC", "container_telemetry")


def generate_container_data(container_id="CONT-A-102", force_risk=False):
    """Generate one synthetic IoT telemetry event."""
    if force_risk or random.random() < 0.25:
        temperature = round(random.uniform(8.5, 13.0), 2)
        humidity = round(random.uniform(86.0, 97.0), 2)
    else:
        temperature = round(random.uniform(4.0, 8.0), 2)
        humidity = round(random.uniform(75.0, 90.0), 2)

    return {
        "container_id": container_id,
        "commodity": "Avocado",
        "temperature_celsius": temperature,
        "humidity_percentage": humidity,
        "vibration_g": round(random.uniform(0.1, 1.5), 2),
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "latitude": round(34.0522 + random.uniform(-0.1, 0.1), 6),
        "longitude": round(-118.2437 + random.uniform(-0.1, 0.1), 6),
    }


def run_local(count, interval, output, force_risk):
    output_path = Path(output)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    with output_path.open("w", encoding="utf-8") as f:
        for i in range(count):
            event = generate_container_data(
                container_id=f"CONT-{chr(65 + (i % 5))}-{100 + i % 20}",
                force_risk=force_risk and i % 3 == 0,
            )
            f.write(json.dumps(event) + "\n")
            print(f"LOCAL EVENT {i + 1}/{count}: {event}")
            if i < count - 1:
                time.sleep(interval)

    print(f"\nSaved {count} events to {output_path}")


def run_kafka(count, interval, broker, topic, force_risk):
    if KafkaProducer is None:
        raise SystemExit("kafka-python is not installed. Run: pip install -r requirements.txt")

    producer = KafkaProducer(
        bootstrap_servers=[broker],
        value_serializer=lambda data: json.dumps(data).encode("utf-8"),
    )

    try:
        for i in range(count):
            event = generate_container_data(
                container_id=f"CONT-{chr(65 + (i % 5))}-{100 + i % 20}",
                force_risk=force_risk and i % 3 == 0,
            )
            producer.send(topic, event)
            producer.flush()
            print(f"KAFKA EVENT {i + 1}/{count}: {event}")
            if i < count - 1:
                time.sleep(interval)
    finally:
        producer.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="AtmoSync synthetic IoT telemetry simulator")
    parser.add_argument("--count", type=int, default=20)
    parser.add_argument("--interval", type=float, default=1.0)
    parser.add_argument("--output", default="data/telemetry_sample.jsonl")
    parser.add_argument("--kafka", action="store_true", help="Send events to Kafka instead of a local JSONL file")
    parser.add_argument("--broker", default=DEFAULT_BROKER)
    parser.add_argument("--topic", default=DEFAULT_TOPIC)
    parser.add_argument("--force-risk", action="store_true", help="Generate more deteriorating conditions")
    args = parser.parse_args()

    if args.kafka:
        run_kafka(args.count, args.interval, args.broker, args.topic, args.force_risk)
    else:
        run_local(args.count, args.interval, args.output, args.force_risk)
