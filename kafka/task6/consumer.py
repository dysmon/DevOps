from kafka import KafkaConsumer
import json

# Kafka broker configuration
BROKER_LIST = ["localhost:9092", "localhost:9093", "localhost:9094"]
TOPIC = "test-topic"

consumer = KafkaConsumer(
    TOPIC,
    bootstrap_servers=BROKER_LIST,
    security_protocol='SASL_PLAINTEXT',
    sasl_mechanism='PLAIN',
    sasl_plain_username='client_consumer',
    sasl_plain_password='client-secret',
    auto_offset_reset='earliest',
    enable_auto_commit=True,
    value_deserializer=lambda v: v.decode('utf-8') 
)

def consume_messages():
    try:
        for message in consumer:
            print(f"Received: {message.value}")
    except Exception as e:
        print(f"Consumer error: {e}")
    finally:
        consumer.close()

if __name__ == "__main__":
    consume_messages()

