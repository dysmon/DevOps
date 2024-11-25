package main

import (
	"context"
	"fmt"
	"log"
	"time"

	"github.com/IBM/sarama"
)

func main() {
	config := sarama.NewConfig()

	config.Net.SASL.Enable = false

	config.Producer.Return.Successes = true

	brokerList := []string{"localhost:9092", "localhost:9093", "localhost:9094"}

	// Produce message
	producer, err := sarama.NewSyncProducer(brokerList, config)
	if err != nil {
		log.Fatalf("Error creating producer: %v", err)
	}
	defer producer.Close()

	message := &sarama.ProducerMessage{
		Topic: "test-topic",
		Value: sarama.StringEncoder("Hello Kafka"),
	}

	partition, offset, err := producer.SendMessage(message)
	if err != nil {
		log.Fatalf("Error sending message: %v", err)
	}

	fmt.Printf("Message sent to partition %d with offset %d\n", partition, offset)

	// Consume message
	consumer, err := sarama.NewConsumer(brokerList, config)
	if err != nil {
		log.Fatalf("Error creating consumer: %v", err)
	}
	defer consumer.Close()

	partitionConsumer, err := consumer.ConsumePartition("test-topic", 0, sarama.OffsetOldest)
	if err != nil {
		log.Fatalf("Error starting partition consumer: %v", err)
	}
	defer partitionConsumer.Close()

	ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
	defer cancel()

	fmt.Println("Consuming messages from Kafka topic:")
	for {
		select {
		case msg := <-partitionConsumer.Messages():
			fmt.Printf("Received message: %s\n", string(msg.Value))
		case <-ctx.Done():
			return
		}
	}
}
