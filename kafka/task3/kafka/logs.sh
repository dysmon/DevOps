
#!/bin/bash
KAFKA_LOG_DIR="/var/lib"
mkdir -p ${KAFKA_LOG_DIR}/kafka-logs-1
mkdir -p ${KAFKA_LOG_DIR}/kafka-logs-2
mkdir -p ${KAFKA_LOG_DIR}/kafka-logs-3

chown -R $(whoami):$(whoami) ${KAFKA_LOG_DIR}/kafka-logs-*

ls ${KAFKA_LOG_DIR}/kafka-logs-1 > /dev/null 2>&1 && echo "kafka-logs-1 created" || echo "you f up"
ls ${KAFKA_LOG_DIR}/kafka-logs-2 > /dev/null 2>&1 && echo "kafka-logs-2 created" || echo "you f up"
ls ${KAFKA_LOG_DIR}/kafka-logs-3 > /dev/null 2>&1 && echo "kafka-logs-3 created" || echo "you f up"