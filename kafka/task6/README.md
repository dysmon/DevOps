
# Kafka Recovery - Disaster Recovery Solution

This task involves implementing a disaster recovery solution for a Kafka cluster running in KRaft mode. The solution includes scripts to randomly stop Kafka brokers at regular intervals while continuously producing and consuming messages to ensure system resilience.

## Prerequisites

- A Kafka cluster running three systemd-managed Kafka containers in KRaft mode. The Kafka setup can be found at [link](https://github.com/dysmon/DevOps/tree/main/kafka/task5).
- Go language installed.
- Docker installed and running.

## Overview

The solution consists of two main scripts:

1. **Stopping a random broker every 15 minutes**.
2. **Monitoring producing and consuming messages from a Kafka topic**.

## Notes
- If two out of three nodes will fall down in quorum, the partitions can left without leader since majority votes (more than a half) needed for election of new leader

## Scripts

### 1. Script: Stop Random Broker

This Bash script randomly stops one of the three Kafka brokers (`kafka-broker-1`, `kafka-broker-2`, `kafka-broker-3`) every 15 minutes.

```bash
#!/bin/bash

BROKERS=("kafka-broker-1" "kafka-broker-2" "kafka-broker-3")

# Function to stop a random broker
stop_random_broker() {
    RANDOM_BROKER=${BROKERS[$RANDOM % ${#BROKERS[@]}]}
    sudo systemctl stop $RANDOM_BROKER
    echo "Stopping broker: $RANDOM_BROKER"
}

# Main loop - stop a random broker every 15 minutes
while true; do
    stop_random_broker
    sleep 900 # 15 minutes
done
```

- **Purpose**: Ensures that one of the brokers is stopped at random intervals to simulate broker failures for disaster recovery testing.
- **Execution**: Run this script in the background to continuously stop a random broker.

### 2. Script: Continuous Message Producer And Consumer

This script runs a Go application that produces and consumes messages continuously to an existing Kafka topic.

```bash
#!/bin/bash

# Navigate to the producer directory
cd producer_consumer

# Continuously produce messages
while true; do
    go run ./main.go
    sleep 5
done
```

- **Purpose**: Ensures continuous message production to Kafka topics, even when brokers are randomly stopped.
- **Execution**: The Go producer script (`main.go`) should be located in the `producer_consumer` directory.

## Running the Solution

1. **Stop Random Broker**: Run the first script in the background to stop a random broker every 15 minutes:
   ```bash
   ./collapsing_nodes.sh &
   ```

2. **Continuous Message Producer, Consumer**: Run the monitoring script to continuously send and consume messages from Kafka topics:
   ```bash
   ./monitoring.sh
   ```
