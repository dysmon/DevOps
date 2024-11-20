
# Kafka [KRAFT] Systemd Configuration

This script automate creation of services for broker.

## Notes

- For make automated, better to name your broker by pattern like `broker{id}.properties`, and important think is should be in `config/`

## Requirements

- Run script with user that have sudoers right and use `sudo` to run

## Script Overview

The `kafka_systemd.sh` script:

1. Take first argument full dir to your kafka
2. Then ask you how much brokers you want, and after that validate given number
3. And after that check from `config/` to brokers
4. Creates a systemd service file for each Kafka broker (e.g., `kafka-broker1.service`) if there are brokers(e.g. in `config/`)
5. Enables and starts each broker as a systemd service.

## Usage

- `sudo bash path/to/kafka_systemd.sh path/to/kafka`
