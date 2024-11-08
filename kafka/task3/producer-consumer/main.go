package main

import (
	"fmt"
	"log"

	"github.com/IBM/sarama"
)

func main() {
	// Kafka configuration
	config := sarama.NewConfig()

	// No SASL authentication
	config.Net.SASL.Enable = false

	config.Producer.Return.Successes = true

	// Set the Kafka broker addresses (replace with your broker addresses)
	brokerList := []string{"localhost:9092", "localhost:9093", "localhost:9094"}

	// Create a new producer
	producer, err := sarama.NewSyncProducer(brokerList, config)
	if err != nil {
		log.Fatalf("Error creating producer: %v", err)
	}
	defer producer.Close()

	// Create a message to send to Kafka
	message := &sarama.ProducerMessage{
		Topic: "test-topic", // Replace with your topic name
		Value: sarama.StringEncoder("Hello Kafka without SASL PLAIN!"),
	}

	// Send the message
	partition, offset, err := producer.SendMessage(message)
	if err != nil {
		log.Fatalf("Error sending message: %v", err)
	}

	// Output the result
	fmt.Printf("Message sent to partition %d with offset %d\n", partition, offset)

	// Create a new consumer
	consumer, err := sarama.NewConsumer(brokerList, config)
	if err != nil {
		log.Fatalf("Error creating consumer: %v", err)
	}
	defer consumer.Close()

	// Start consuming messages from the beginning of the topic
	partitionConsumer, err := consumer.ConsumePartition("test-topic", 0, sarama.OffsetOldest)
	if err != nil {
		log.Fatalf("Error starting partition consumer: %v", err)
	}
	defer partitionConsumer.Close()

	// Consume messages
	fmt.Println("Consuming messages from Kafka topic:")
	for msg := range partitionConsumer.Messages() {
		fmt.Printf("Received message: %s\n", string(msg.Value))
	}
}
