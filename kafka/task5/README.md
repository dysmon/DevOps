
# Kafka [KRAFT] Systemd Configuration with Docker

This project automates the creation and configuration of Apache Kafka brokers as Docker containers, each managed as a separate systemd service. Each broker is assigned its own systemd unit, enabling easy management of individual brokers.

## Notes

- This configuration uses Confluent's Kafka Docker image (`confluentinc/cp-kafka:7.7.0`).
- Each broker is configured with unique ports to avoid conflicts.

## Requirements

- Docker

Ensure Docker is installed and running. This script also assumes systemd is available on the host system.

## Script Overview

The `kafka_systemd.sh` script:
1. Creates a Docker network (`kafka-net`) if it does not already exist.
2. Configures Kafka brokers with unique ports and environment variables for each broker.
3. Creates a systemd service file for each Kafka broker (e.g., `kafka-1.service`).
4. Enables and starts each broker as a systemd service, allowing you to manage each broker individually.

## Usage

1. Clone this repository or copy the `kafka_systemd.sh` file.
2. Make the script executable:

   ```bash
   chmod +x kafka_systemd.sh
   ```

3. Run the script with sudo privileges to set up Kafka brokers as systemd services:

   ```bash
   sudo ./kafka_systemd.sh
   ```

   This will:
   - Create a Docker network `kafka-net` if it does not exist.
   - Set up and start Kafka brokers as Docker containers.
   - Generate systemd unit files for each broker (`/etc/systemd/system/kafka-broker-1.service`, etc.).

4. The script will output the creation and enabling status of each Kafka broker service.

## Verifying Cluster Operation

To verify that the cluster remains operational after stopping a broker:
1. Stop a Kafka broker using `systemctl stop kafka-broker-<broker_id>.service`.
2. Check the logs of the remaining brokers to ensure they handle the missing broker gracefully.
3. Restart the stopped broker if needed.

## Systemd Unit File Details

Each generated systemd unit file includes:
- Commands to run the Kafka broker in Docker, with broker-specific environment variables and ports.
- `ExecStartPre` and `ExecStopPost` directives to ensure any existing container with the same name is removed before starting and after stopping.

## Cleanup

To remove the Kafka broker services, stop and disable each broker, then delete the systemd unit files:

```bash
sudo systemctl stop kafka-broker-1.service kafka-broker-2.service kafka-broker-3.service
sudo systemctl disable kafka-broker-1.service kafka-broker-2.service kafka-broker-3.service
sudo rm /etc/systemd/system/kafka-broker-*.service
sudo systemctl daemon-reload
```

## Troubleshooting

If any service fails to start:
- Check the logs for errors:

  ```bash
  sudo journalctl -u kafka-broker-<broker_id>.service
  ```

- Ensure Docker is running and the `kafka-net` network is accessible.
