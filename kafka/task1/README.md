
# Kafka Cluster Setup with Three Brokers

## Objective
Set up and configure an Apache Kafka cluster with three brokers (`broker01`, `broker02`, `broker03`). Ensure that the brokers are correctly configured and can operate together as a unified cluster. Additionally, create a Kafka topic with multiple partitions and verify the distribution of these partitions across the brokers.

## Prerequisites
- Docker and Docker Compose installed on the host machine.

## Docker Compose Configuration

This project uses Docker Compose to set up the Kafka cluster with three brokers, each running in a separate container. Additionally, a Zookeeper service is included for Kafka coordination.

### Docker Compose File (`docker-compose.yml`)

```yaml
version: '3.7'

services:
  zookeeper:
    image: confluentinc/cp-zookeeper:7.3.0
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
      ZOOKEEPER_SERVER_ID: 1
    ports:
      - "2181:2181"

  kafka-1:
    image: confluentinc/cp-kafka:7.3.0
    container_name: broker01
    ports:
      - "9092:9092"
      - "29092:29092"
    environment:
      KAFKA_ADVERTISED_LISTENERS: INTERNAL://kafka-1:19092,EXTERNAL://127.0.0.1:9092,DOCKER://host.docker.internal:29092
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: INTERNAL:PLAINTEXT,EXTERNAL:PLAINTEXT,DOCKER:PLAINTEXT
      KAFKA_INTER_BROKER_LISTENER_NAME: INTERNAL
      KAFKA_ZOOKEEPER_CONNECT: "zookeeper:2181"
      KAFKA_BROKER_ID: 1
    depends_on:
      - zookeeper

  kafka-2:
    image: confluentinc/cp-kafka:7.3.0
    container_name: broker02
    ports:
      - "9093:9093"
      - "29093:29093"
    environment:
      KAFKA_ADVERTISED_LISTENERS: INTERNAL://kafka-2:19093,EXTERNAL://127.0.0.1:9093,DOCKER://host.docker.internal:29093
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: INTERNAL:PLAINTEXT,EXTERNAL:PLAINTEXT,DOCKER:PLAINTEXT
      KAFKA_INTER_BROKER_LISTENER_NAME: INTERNAL
      KAFKA_ZOOKEEPER_CONNECT: "zookeeper:2181"
      KAFKA_BROKER_ID: 2
    depends_on:
      - zookeeper

  kafka-3:
    image: confluentinc/cp-kafka:7.3.0
    container_name: broker03
    ports:
      - "9094:9094"
      - "29094:29094"
    environment:
      KAFKA_ADVERTISED_LISTENERS: INTERNAL://kafka-3:19094,EXTERNAL://127.0.0.1:9094,DOCKER://host.docker.internal:29094
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: INTERNAL:PLAINTEXT,EXTERNAL:PLAINTEXT,DOCKER:PLAINTEXT
      KAFKA_INTER_BROKER_LISTENER_NAME: INTERNAL
      KAFKA_ZOOKEEPER_CONNECT: "zookeeper:2181"
      KAFKA_BROKER_ID: 3
    depends_on:
      - zookeeper
```

### Services Overview
1. **Zookeeper**: 
   - Essential for managing Kafka brokers and their metadata. It runs on port `2181`.
   
2. **Kafka Brokers**:
   - **broker01**: Exposes ports `9092` and `29092`.
   - **broker02**: Exposes ports `9093` and `29093`.
   - **broker03**: Exposes ports `9094` and `29094`.
   
Each Kafka broker is connected to Zookeeper and advertises internal, external, and Docker-specific listeners for proper communication.

## Setup Instructions

### 1. Clone the repository
If you haven’t already, clone the repository containing the `docker-compose.yml` file.

```bash
git clone <repository_url>
cd <repository_folder>
```

### 2. Start the Kafka Cluster
Run the following command to start all the services (Zookeeper and Kafka brokers):

```bash
docker-compose up -d
```

This will start the Kafka brokers (`broker01`, `broker02`, `broker03`) and Zookeeper. The `-d` flag runs the containers in the background.

### 3. Verify the Kafka Cluster
Once the cluster is up and running, verify that all three Kafka brokers are operating and visible.

```bash
docker ps
```

You should see three Kafka brokers and the Zookeeper service running.

### 4. Create a Kafka Topic with Multiple Partitions
Use the following command to create a Kafka topic named `hi-topic` with 6 partitions and a replication factor of 3. The `--replication-factor 3` ensures that the topic has replicas across different brokers.

```bash
docker exec -it broker01 kafka-topics --create --bootstrap-server localhost:19092 --replication-factor 3 --partitions 6 --topic hi-topic
```

### 5. Verify the Topic and Partition Distribution
Once the topic is created, you can describe it to verify the distribution of partitions across brokers.

```bash
docker exec -it broker01 kafka-topics --describe --bootstrap-server localhost:19092 --topic hi-topic
```

This command will show details of the `hi-topic`, including the partition distribution across the brokers in the Kafka cluster.

## Troubleshooting

- If the brokers don’t start or communicate, check the Docker logs of each container using the following command:
  
  ```bash
  docker logs <container_name>
  ```

  Look for any error messages related to Zookeeper connection or broker startup issues.
  
- Ensure that your advertised listeners are correctly configured, especially for external connections, and that your Docker network is set up correctly.

## Conclusion
You’ve successfully set up a Kafka cluster with three brokers and verified the distribution of topic partitions across the brokers. This setup can be scaled and adjusted to suit your needs for message streaming and distributed data management.
