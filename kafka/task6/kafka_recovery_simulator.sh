#!/bin/bash

BROKER_SERVICES=("kafka-broker1.service" "kafka-broker2.service" "kafka-broker3.service")

LOG_FILE="/var/log/kafka_recovery_simulator.log"

log_message() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOG_FILE"
}

stop_random_broker() {
    RANDOM_BROKER=${BROKER_SERVICES[$RANDOM % ${#BROKER_SERVICES[@]}]}
    log_message "Stopping broker: $RANDOM_BROKER"
    systemctl stop $RANDOM_BROKER

    sleep 5 
    if ! systemctl is-active --quiet $RANDOM_BROKER; then
        log_message "$RANDOM_BROKER successfully stopped."
    else
        log_message "Failed to stop $RANDOM_BROKER."
    fi
}

restart_all_brokers() {
    log_message "Restarting all brokers..."
    for BROKER in "${BROKER_SERVICES[@]}"; do
        systemctl start $BROKER
        if systemctl is-active --quiet $BROKER; then
            log_message "$BROKER is running."
        else
            log_message "Failed to start $BROKER."
        fi
    done
}

trap restart_all_brokers EXIT

while true; do
    stop_random_broker
    log_message "Sleeping for 15 minutes before the next iteration..."
    sleep 900  
done

