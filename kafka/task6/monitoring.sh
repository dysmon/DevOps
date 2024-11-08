#!/bin/bash

# RUN THE SCRIPT IN CURRENT DIRECTORY
cd consumer_producer
while true; do
	go run ./main.go
	sleep 5
done
