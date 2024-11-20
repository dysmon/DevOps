#!/bin/bash

echo "Generating Kafka cluster ID..."

CLUSTER_ID=$($KAFKA_BIN_DIR/kafka-storage.sh random-uuid)

echo "CLUSTER_ID: $CLUSTER_ID"

bin/kafka-storage.sh format --config $KAFKA_CONFIG_DIR/broker1.properties --cluster-id $CLUSTER_ID
bin/kafka-storage.sh format --config $KAFKA_CONFIG_DIR/broker2.properties --cluster-id $CLUSTER_ID
bin/kafka-storage.sh format --config $KAFKA_CONFIG_DIR/broker3.properties --cluster-id $CLUSTER_ID
echo "Brokers formatted with cluster ID: $CLUSTER_ID"

echo "Kafka brokers formatted with cluster ID."
