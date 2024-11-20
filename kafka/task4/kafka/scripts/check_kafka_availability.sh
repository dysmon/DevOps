#!/bin/bash

KAFKA_BROKER="localhost 9092"
MAX_RETRIES=10
RETRY_DELAY=5

check_kafka() {
  nc -z $KAFKA_BROKER  
  return $?
}

attempt=1
while [[ $attempt -le $MAX_RETRIES ]]; do
  echo "Checking Kafka broker at $KAFKA_BROKER (Attempt $attempt/$MAX_RETRIES)..."
  if check_kafka; then
    echo "Kafka is up!"
    break
  else
    echo "Kafka is down. Retrying in $RETRY_DELAY seconds..."
    sleep $RETRY_DELAY
  fi
  attempt=$((attempt + 1))
done

if [[ $attempt -gt $MAX_RETRIES ]]; then
  echo "Kafka is not available after $MAX_RETRIES attempts. Exiting."
  exit 1
fi
