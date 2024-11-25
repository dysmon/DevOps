#!/bin/bash

docker exec kafka-1 kafka-topics --create --bootstrap-server kafka-1:19092 --replication-factor 3 --partitions 6 --topic hi-topic
docker exec kafka-1 kafka-topics --describe --bootstrap-server kafka-1:19092 --topic hi-topic

