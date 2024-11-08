#!/bin/bash

BROKERS=("kafka-broker-1" "kafka-broker-2" "kafka-broker-3")

# Function to stop a random broker
stop_random_broker() {
    RANDOM_BROKER=${BROKERS[$RANDOM % ${#BROKERS[@]}]}
    sudo systemctl stop $RANDOM_BROKER
    echo "Stopping broker: $RANDOM_BROKER"
}

# MAIN
while true; do
	stop_random_broker
	sleep 900 # 15 MIN
done

