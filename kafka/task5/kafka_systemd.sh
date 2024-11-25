#!/bin/bash

create() {
# Variables
BROKER_ID=$1  # Broker ID (e.g., 1, 2, 3 for brokers)
DOCKER_NETWORK="kafka-net"
KAFKA_IMAGE="confluentinc/cp-kafka:7.7.0"
KAFKA_CONTAINER_NAME="kafka-$BROKER_ID"
KAFKA_PORT_INTERNAL="$2"
KAFKA_PORT_EXTERNAL="$3"
KAFKA_PORT_CONTROLLER="$4"
KAFKA_NODE_ID=$BROKER_ID
KAFKA_LOG_DIRS="/tmp/kraft-controller-logs"

# Kafka specific environment variables
KAFKA_LISTENERS="INTERNAL://:$KAFKA_PORT_INTERNAL,EXTERNAL://:$KAFKA_PORT_EXTERNAL,CONTROLLER://kafka-$BROKER_ID:$KAFKA_PORT_CONTROLLER"
KAFKA_ADVERTISED_LISTENERS="INTERNAL://kafka-$BROKER_ID:$KAFKA_PORT_INTERNAL,EXTERNAL://127.0.0.1:$KAFKA_PORT_EXTERNAL"
KAFKA_LISTENER_SECURITY_PROTOCOL_MAP="CONTROLLER:PLAINTEXT,INTERNAL:PLAINTEXT,EXTERNAL:PLAINTEXT"
KAFKA_INTER_BROKER_LISTENER_NAME="INTERNAL"
KAFKA_CONTROLLER_QUORUM_VOTERS="1@kafka-1:$KAFKA_PORT_CONTROLLER,2@kafka-2:29093,3@kafka-3:29094"
KAFKA_CONTROLLER_LISTENER_NAMES="CONTROLLER"
CLUSTER_ID="MkU3OEVBNTcwNTJENDM2Qk"

# Create the systemd unit file for this broker
SYSTEMD_FILE="/etc/systemd/system/kafka-broker-$BROKER_ID.service"

docker pull $KAFKA_IMAGE

echo /usr/bin/docker run --name $KAFKA_CONTAINER_NAME --network $DOCKER_NETWORK \
  -e KAFKA_PROCESS_ROLES="broker,controller" \
  -e KAFKA_LISTENERS="$KAFKA_LISTENERS" \
  -e KAFKA_ADVERTISED_LISTENERS="$KAFKA_ADVERTISED_LISTENERS" \
  -e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP="$KAFKA_LISTENER_SECURITY_PROTOCOL_MAP" \
  -e KAFKA_INTER_BROKER_LISTENER_NAME="$KAFKA_INTER_BROKER_LISTENER_NAME" \
  -e KAFKA_CONTROLLER_QUORUM_VOTERS="$KAFKA_CONTROLLER_QUORUM_VOTERS" \
  -e KAFKA_CONTROLLER_LISTENER_NAMES="$KAFKA_CONTROLLER_LISTENER_NAMES" \
  -e KAFKA_NODE_ID="$KAFKA_NODE_ID" \
  -e KAFKA_LOG_DIRS="$KAFKA_LOG_DIRS" \
  -e CLUSTER_ID="$CLUSTER_ID" \
  -p $KAFKA_PORT_EXTERNAL:$KAFKA_PORT_EXTERNAL \
  -p $KAFKA_PORT_CONTROLLER:$KAFKA_PORT_CONTROLLER \
  $KAFKA_IMAGE

cat <<EOF > "$SYSTEMD_FILE"
[Unit]
Description=Kafka Broker $BROKER_ID
After=docker.service
Requires=docker.service

[Service]
Restart=always
ExecStartPre=/usr/bin/docker rm -f $KAFKA_CONTAINER_NAME
ExecStart=/usr/bin/docker run --name $KAFKA_CONTAINER_NAME --network $DOCKER_NETWORK \
  -e KAFKA_PROCESS_ROLES="broker,controller" \
  -e KAFKA_LISTENERS="$KAFKA_LISTENERS" \
  -e KAFKA_ADVERTISED_LISTENERS="$KAFKA_ADVERTISED_LISTENERS" \
  -e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP="$KAFKA_LISTENER_SECURITY_PROTOCOL_MAP" \
  -e KAFKA_INTER_BROKER_LISTENER_NAME="$KAFKA_INTER_BROKER_LISTENER_NAME" \
  -e KAFKA_CONTROLLER_QUORUM_VOTERS="$KAFKA_CONTROLLER_QUORUM_VOTERS" \
  -e KAFKA_CONTROLLER_LISTENER_NAMES="$KAFKA_CONTROLLER_LISTENER_NAMES" \
  -e KAFKA_NODE_ID="$KAFKA_NODE_ID" \
  -e KAFKA_LOG_DIRS="$KAFKA_LOG_DIRS" \
  -e CLUSTER_ID="$CLUSTER_ID" \
  -p $KAFKA_PORT_EXTERNAL:$KAFKA_PORT_EXTERNAL \
  -p $KAFKA_PORT_CONTROLLER:$KAFKA_PORT_CONTROLLER \
  $KAFKA_IMAGE
ExecStop=/usr/bin/docker stop $KAFKA_CONTAINER_NAME
ExecStopPost=/usr/bin/docker rm $KAFKA_CONTAINER_NAME

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kafka-broker-$BROKER_ID.service
systemctl start kafka-broker-$BROKER_ID.service

echo "Kafka Broker $BROKER_ID systemd service created and enabled."
}

# main
if ! docker network ls --filter name=kafka-net --quiet | grep -q .; then
    echo "kafka-net network not found. Creating kafka-net network..."
    docker network create kafka-net
fi

for i in {1..3}
do
	INTERNAL_PORT=$((19091 + i))
	EXTERNAL_PORT=$((9091 + i))
	CONTROLLER_PORT=$((29091 + i))
	create $i $INTERNAL_PORT $EXTERNAL_PORT $CONTROLLER_PORT
done
