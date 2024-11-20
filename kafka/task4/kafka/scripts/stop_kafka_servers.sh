#!/bin/bash

echo "Stopping Kafka brokers..."

BROKER_PORTS=("9092" "9094" "9096")

for port in "${BROKER_PORTS[@]}"; do
    echo "Stopping Kafka broker on port $port..."

    pid=$(lsof -ti:"$port")

    if [ -n "$pid" ]; then
        kill "$pid"
        echo "Kafka broker on port $port stopped successfully."
    else
        echo "No Kafka broker running on port $port."
    fi
done

echo "Kafka brokers stopped."

