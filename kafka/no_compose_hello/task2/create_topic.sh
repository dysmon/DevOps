#!/bin/bash

docker exec kafka-1 kafka-topics --create --bootstrap-server kafka-1:19092 kafka-2:19093 kafka-3:19094 --replication-factor 3 --partitions 1 --topic test-topic --command-config /tmp/client.properties

