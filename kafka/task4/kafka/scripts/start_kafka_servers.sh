#!/bin/bash

echo "Starting Kafka servers..."
nohup $KAFKA_BIN_DIR/kafka-server-start.sh $KAFKA_CONFIG_DIR/broker1.properties &
nohup $KAFKA_BIN_DIR/kafka-server-start.sh $KAFKA_CONFIG_DIR/broker2.properties &
nohup $KAFKA_BIN_DIR/kafka-server-start.sh $KAFKA_CONFIG_DIR/broker3.properties &
sleep 5  

echo "Adding ACLs..."