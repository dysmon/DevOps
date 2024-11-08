
# Kafka Cluster without Zookeeper using KRaft Mode

This project demonstrates setting up a Kafka cluster without Zookeeper, using **KRaft** mode, and verifying its functionality with a simple Go application for producing and consuming messages.

## Project Structure

- **Docker Compose File**: Sets up a 3-broker Kafka cluster using Confluent's Kafka image in KRaft mode (i.e., without Zookeeper).
- **Go Application**: A sample Go application that produces and consumes messages to verify that the Kafka cluster works as expected.

## Prerequisites

- **Docker** and **Docker Compose**
- **Go** installed on your machine

## Running the Kafka Cluster

1. Clone the repository.

   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. Start the Kafka cluster using Docker Compose.

   ```bash
   docker-compose up -d
   ```

3. Verify the cluster is running correctly. You should see three brokers in the logs:

   ```bash
   docker-compose logs -f
   ```

## Running the Go Application

1. Install the Sarama library for Kafka in Go:

   ```bash
   go get github.com/IBM/sarama
   ```

2. Run the Go application to produce and consume messages:

   ```bash
   go run main.go
   ```

   - The application will produce a message to the topic `test-topic` and consume messages from the same topic.

## Configuration Details

- Kafka brokers use **plaintext communication** without SASL authentication.
- The cluster operates in **KRaft mode** with a 3-broker setup.

## Important Notes

- Ensure that the **Go application** is configured with the correct broker addresses.
- The **topic name** used in the Go application is `test-topic`. Adjust the topic as needed.
