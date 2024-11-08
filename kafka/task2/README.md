
# Kafka with SASL Authentication (PLAIN Mechanism)

## Overview

This guide covers configuring Kafka to use SASL (Simple Authentication and Security Layer) for both client-broker and inter-broker communication. We use the PLAIN mechanism for SASL authentication, ensuring secure communication between Kafka clients and brokers, as well as between brokers in a Kafka cluster.

## Prerequisites

- Docker and Docker Compose installed.
- Go installed (for testing the Kafka producer/consumer).
- SASL credentials prepared (username and password for both brokers and clients).

## Docker Compose Configuration

This setup uses three Kafka brokers and a Zookeeper instance. Each Kafka broker is configured to communicate using SASL_PLAINTEXT.

### Zookeeper Configuration

Zookeeper is configured to use SASL authentication as well. The environment variable `KAFKA_OPTS` is set to reference a JAAS configuration file.

```yaml
version: '3.7'

services:
  zookeeper:
    image: confluentinc/cp-zookeeper:7.3.0
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
      KAFKA_OPTS: -Djava.security.auth.login.config=/etc/kafka/secrets/zookeeper_jaas.conf
    volumes:
      - ./zookeeper_jaas.conf:/etc/kafka/secrets/zookeeper_jaas.conf
    ports:
      - "2181:2181"
```

### Kafka Brokers Configuration

Each broker is configured to support SASL for both internal (inter-broker) and external client communication. The `KAFKA_OPTS` environment variable points to the JAAS configuration file containing the SASL credentials.

```yaml
  kafka-1:
    image: confluentinc/cp-kafka:7.3.0
    container_name: broker01
    ports:
      - "9092:9092"
      - "29092:29092"
    environment:
      KAFKA_ADVERTISED_LISTENERS: INTERNAL://kafka-1:19092,EXTERNAL://127.0.0.1:9092,DOCKER://host.docker.internal:29092
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: INTERNAL:SASL_PLAINTEXT,EXTERNAL:SASL_PLAINTEXT,DOCKER:SASL_PLAINTEXT
      KAFKA_INTER_BROKER_LISTENER_NAME: INTERNAL
      KAFKA_ZOOKEEPER_CONNECT: "zookeeper:2181"
      KAFKA_BROKER_ID: 1
      KAFKA_OPTS: "-Djava.security.auth.login.config=/etc/kafka/secrets/broker_jaas.conf"
      KAFKA_SASL_ENABLED_MECHANISMS: PLAIN
      KAFKA_SASL_MECHANISM_INTER_BROKER_PROTOCOL: PLAIN
    volumes:
      - ./broker_jaas.conf:/etc/kafka/secrets/broker_jaas.conf
```

This configuration is repeated for `kafka-2` and `kafka-3` with appropriate port and listener changes.

### JAAS Configuration Files

For Zookeeper (`zookeeper_jaas.conf`):

```bash
Server {
   org.apache.zookeeper.server.auth.DigestLoginModule required
   user_super="adminsecret"
   user_kafka="kafkasecret";
};
```

For Kafka brokers (`broker_jaas.conf`):

```bash
KafkaServer {
  org.apache.kafka.common.security.plain.PlainLoginModule required
  username="broker"
  password="broker-secret"
  user_broker="broker-secret"
  user_client="client-secret";
};
```

## Testing with Go Producer/Consumer

You can test the Kafka setup using a Go producer and consumer. The Go code uses the Sarama library with SASL authentication:

```go
package main

import (
	"fmt"
	"log"
	"github.com/IBM/sarama"
)

func main() {
	config := sarama.NewConfig()
	config.Net.SASL.Enable = true
	config.Net.SASL.Mechanism = sarama.SASLTypePlaintext
	config.Net.SASL.User = "client"
	config.Net.SASL.Password = "client-secret"

	brokerList := []string{"localhost:9092", "localhost:9093", "localhost:9094"}

	producer, err := sarama.NewSyncProducer(brokerList, config)
	if err != nil {
		log.Fatalf("Error creating producer: %v", err)
	}
	defer producer.Close()

	message := &sarama.ProducerMessage{
		Topic: "test-topic",
		Value: sarama.StringEncoder("Hello Kafka with SASL PLAIN!"),
	}

	partition, offset, err := producer.SendMessage(message)
	if err != nil {
		log.Fatalf("Error sending message: %v", err)
	}

	fmt.Printf("Message sent to partition %d with offset %d
", partition, offset)
}
```

This code demonstrates both producing and consuming messages with SASL authentication.

## Commands to Run

1. Start the services:
   ```bash
   docker-compose up -d
   ```

2. Run Go app to verify messages in the topic.

