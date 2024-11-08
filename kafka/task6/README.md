
# Task #6: Kafka Recovery - Disaster Recovery Solution

This task involves implementing a disaster recovery solution for a Kafka cluster running in KRaft mode. The solution includes scripts to randomly stop Kafka brokers at regular intervals while continuously producing and consuming messages to ensure system resilience.

## Prerequisites

- A Kafka cluster running three systemd-managed Kafka containers in KRaft mode. The Kafka setup can be found at [link](https://github.com/dysmon/DevOps/tree/main/kafka/task5).
- Go language installed.
- Docker installed and running.

## Overview

The solution consists of three main scripts:

1. **Stopping a random broker every 15 minutes**.
2. **Continuously producing messages to Kafka topics**.
3. **Monitoring and consuming messages from a Kafka topic**.

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

### 2. Script: Continuous Message Producer

This script runs a Go application that produces messages continuously to an existing Kafka topic.

```bash
#!/bin/bash

# Navigate to the producer directory
cd producer

# Continuously produce messages
while true; do
    go run ./main.go
    sleep 5
done
```

- **Purpose**: Ensures continuous message production to Kafka topics, even when brokers are randomly stopped.
- **Execution**: The Go producer script (`main.go`) should be located in the `producer` directory.

### 3. Script: Consumer Monitoring

This script monitors and consumes messages from a Kafka topic using the Kafka console consumer.

```bash
#!/bin/bash

docker exec -it kafka-1 kafka-console-consumer --bootstrap-server kafka-1:19092,kafka-2:19093,kafka-3:19094 --topic hi-topic --from-beginning
```

- **Purpose**: Verifies that messages are being consumed from the Kafka topic despite broker failures.
- **Execution**: This script runs a Kafka console consumer inside the `kafka-1` container.

## Running the Solution

1. **Stop Random Broker**: Run the first script in the background to stop a random broker every 15 minutes:
   ```bash
   ./stop_random_broker.sh &
   ```

2. **Continuous Message Producer**: Run the producer script to continuously send messages to Kafka topics:
   ```bash
   ./produce_continuous.sh &
   ```

3. **Monitor Kafka Topic**: Use the consumer script to monitor and consume messages from a Kafka topic:
   ```bash
   ./monitor_consumer.sh
   ```

## Notes

- The Kafka cluster runs in KRaft mode, which eliminates the need for ZooKeeper.
- Ensure that all required services (Kafka, Docker, Go) are running properly before starting the scripts.
- Modify the `kafka-console-consumer` command to match your Kafka topic name and bootstrap servers if needed.

## Conclusion

This disaster recovery solution tests Kafka's resilience by continuously stopping brokers and checking that message flow is not disrupted. The producer and consumer scripts validate Kafka's ability to handle broker failures while maintaining topic availability.
