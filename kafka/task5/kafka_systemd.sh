#!/bin/bash

KAFKA_DIR=$1
CONFIG_DIR="$KAFKA_DIR/config"
SYSTEMD_DIR="/etc/systemd/system"

create_service_file() {
  local broker_id=$1
  local properties_file="broker${broker_id}.properties"
  local service_file="${SYSTEMD_DIR}/kafka-broker${broker_id}.service"

  if [[ -f "$service_file" ]]; then
    echo "Service file for Broker ${broker_id} already exists. Skipping..."
    return
  fi

  cat <<EOL > "$service_file"
[Unit]
Description=Apache Kafka Broker ${broker_id}
After=network.target

[Service]
User=$(whoami)
ExecStart=${KAFKA_DIR}/bin/kafka-server-start.sh ${CONFIG_DIR}/${properties_file}
ExecStop=${KAFKA_DIR}/bin/kafka-server-stop.sh
Restart=on-failure
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
EOL

  echo "Created systemd service for Broker ${broker_id}: $service_file"
}

# Main script
echo "Setting up Kafka broker services..."
read -p "Enter the number of brokers: " num_brokers

if [[ ! $num_brokers =~ ^[0-9]+$ || $num_brokers -le 0 ]]; then
  echo "Invalid number of brokers. Please enter a positive integer."
  exit 1
fi

for ((i = 1; i <= num_brokers; i++)); do
  if [[ -f "${CONFIG_DIR}/broker${i}.properties" ]]; then
    create_service_file "$i"
  else
    echo "Properties file broker${i}.properties not found in ${CONFIG_DIR}. Skipping..."
  fi
done

echo "Reloading systemd daemon to apply changes..."
systemctl daemon-reload

echo "Enabling and starting Kafka broker services..."
for ((i = 1; i <= num_brokers; i++)); do
  if [[ -f "${SYSTEMD_DIR}/kafka-broker${i}.service" ]]; then
    systemctl enable kafka-broker${i}.service
    systemctl start kafka-broker${i}.service
  fi
done

echo "Kafka broker services have been set up."

