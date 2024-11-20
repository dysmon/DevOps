#!/bin/bash

echo "Generating Kafka cluster ID..."

# Generate a random cluster ID using kafka-storage.sh
CLUSTER_ID=$(bin/kafka-storage.sh random-uuid)

echo "Kafka cluster ID generated: $CLUSTER_ID"

rm -rf /var/lib/kafka-logs-*/

# Step 2: Format each Kafka broker with the generated cluster ID
echo "Formatting Kafka brokers..."

# Format broker1
bin/kafka-storage.sh format --config ./config/kraft/broker1.properties --cluster-id $CLUSTER_ID
echo "Broker1 formatted with cluster ID: $CLUSTER_ID"

# Format broker2
bin/kafka-storage.sh format --config ./config/kraft//broker2.properties --cluster-id $CLUSTER_ID
echo "Broker2 formatted with cluster ID: $CLUSTER_ID"

# Format broker3
bin/kafka-storage.sh format --config ./config/kraft/broker3.properties --cluster-id $CLUSTER_ID
echo "Broker3 formatted with cluster ID: $CLUSTER_ID"

echo "Kafka brokers formatted with cluster ID."
