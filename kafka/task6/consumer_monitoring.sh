docker exec -it kafka-1 kafka-console-consumer --bootstrap-server kafka-1:19092 kafka-2:19093 kafka-3:19094 --topic hi-topic --from-beginning

