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
	config.Net.SASL.User = "broker"
	config.Net.SASL.Password = "broker-secret"

	config.Producer.Return.Successes = true

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

	fmt.Printf("Message sent to partition %d with offset %d\n", partition, offset)

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

	fmt.Println("Consuming messages from Kafka topic:")
	for msg := range partitionConsumer.Messages() {
		fmt.Printf("Received message: %s\n", string(msg.Value))
	}
}
