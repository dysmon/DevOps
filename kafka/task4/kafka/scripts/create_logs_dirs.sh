#!/bin/bash

mkdir -p ${KAFKA_LOG_DIR}/kafka-logs-1
mkdir -p ${KAFKA_LOG_DIR}/kafka-logs-2
mkdir -p ${KAFKA_LOG_DIR}/kafka-logs-3

ls ${KAFKA_LOG_DIR}/kafka-logs-1 > /dev/null 2>&1 && echo "kafka-logs-1 created" || echo "kafka-logs-1 did not created."
ls ${KAFKA_LOG_DIR}/kafka-logs-2 > /dev/null 2>&1 && echo "kafka-logs-2 created" || echo "kafka-logs-2 did not created."
ls ${KAFKA_LOG_DIR}/kafka-logs-3 > /dev/null 2>&1 && echo "kafka-logs-3 created" || echo "kafka-logs-3 did not created."