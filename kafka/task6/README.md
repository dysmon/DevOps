
# Kafka Recovery - Disaster Recovery Solution

This task involves implementing a disaster recovery solution for a Kafka cluster running in KRaft mode. The solution includes scripts to randomly stop Kafka brokers at regular intervals while continuously producing and consuming messages to ensure system resilience.

## Prerequisites

- A Kafka cluster running three systemd-managed Kafka containers in KRaft mode. 
- Change the options value in the python scripts for make suiable for your kafka.

## Overview

The solution consists of two main scripts:

1. **Stopping a random broker every 15 minutes**.
2. **Monitoring producing and consuming messages from a Kafka topic**.

## Notes
- If two out of three nodes will fall down in quorum, the partitions can left without leader since majority votes (more than a half) needed for election of new leader

## Scripts

Run the codes in sudo mode.

### 1. Script: Stop Random Broker

This Bash script randomly stops one of the three Kafka brokers (`kafka-broker-1`, `kafka-broker-2`, `kafka-broker-3`) every 15 minutes.

- **Execution**: Run this script in the background to continuously stop a random broker.

### 2. Script: Continuous Message Producer And Consumer

This script runs a python apps `consumer.py` and `producer.py`

- **Execution**: Run the codes, producer will autmatically create random integer, and consumer will catch the messages

## Running the Solution

1. **Stop Random Broker**: Run the first script in the background to stop a random broker every 15 minutes:
   ```bash
   ./kafka_recovery_simulator.sh &
   ```

2. **Run the python codes**: Run the producer and consumer scripts.
