# TASK1 of kafka

Configure Kafka to support either SASL or SSL for client-broker and inter-broker
communication.
Ensure that producers can send messages and consumers can receive them
successfully.
Examples of the configuration settings needed for clients (producers and
consumers) to establish a secure connection

```json
{
"sasl.username": "admin",
"sasl.admin": "admin",
"security.protocol": "SASL_SSL",
"sasl.mechanism": "SCRAM-SHA-256",
"ssl.ca.location": "/etc/ssl/certs/my.crt"
}
{
"sasl.username": "admin",
"sasl.admin": "admin",
"security.protocol": "SASL_PLAINTEXT",
"sasl.mechanism": "PLAIN"
}
```

Note – SASL_PLAINTEXT with PLAIN is easier to implement

## Instructions

### 1. Add jaas.conf and configure them with username and password files for sasl

```bash
cd config
touch kafka-client-jaas.conf kafka-server-jaas.conf zookeeper-jaas.conf
```

and configure them

```conf
# kafka-client-jaas.conf
KafkaClient {
   	org.apache.kafka.common.security.plain.PlainLoginModule required
	username="client_producer"
	password="client-secret";
};
```

```conf
# kafka-server-jaas.conf
KafkaServer {
	org.apache.kafka.common.security.plain.PlainLoginModule required
	username="admin"
	password="admin-secret"
	user_admin="admin-secret"
	user_client_consumer="client-secret"
	user_client_producer="client-secret";
};
```

```conf
# zookeeper-jaas.conf
Server {
	org.apache.zookeeper.server.auth.DigestLoginModule required
	user_admin="admin-secret";
};

```

and run one script that makes permanaent log dirs

```bash
sudo logs.sh
```

### 2. Change producer.properties and consumer.properties

```properties
# producer.properties
bootstrap.servers=localhost:9092

compression.type=none

sasl.mechanism=PLAIN
security.protocol=SASL_PLAINTEXT
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="client_producer" password="client-secret";

```

```properties
# consumer.properties
bootstrap.servers=localhost:9092


sasl.mechanism=PLAIN
security.protocol=SASL_PLAINTEXT
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="client_consumer" password="client-secret";


# consumer group id
group.id=test-consumer-group
```

### 3. configure brokers with sasl enabling

```properties
# broker1.properties
broker.id=1
log.dirs=/var/lib/kafka-logs-1
listeners=SASL_PLAINTEXT://localhost:9092
advertised.listeners=SASL_PLAINTEXT://localhost:9092
security.inter.broker.protocol=SASL_PLAINTEXT
sasl.mechanism.inter.broker.protocol=PLAIN
sasl.enabled.mechanisms=PLAIN
zookeeper.connect=localhost:2181

######################################################

# broker2.properties
broker.id=2
log.dirs=/var/lib/kafka-logs-2
listeners=SASL_PLAINTEXT://localhost:9093
advertised.listeners=SASL_PLAINTEXT://localhost:9093
security.inter.broker.protocol=SASL_PLAINTEXT
sasl.mechanism.inter.broker.protocol=PLAIN
sasl.enabled.mechanisms=PLAIN
zookeeper.connect=localhost:2181


######################################################

# broker3.properties
broker.id=3
log.dirs=/var/lib/kafka-logs-3
listeners=SASL_PLAINTEXT://localhost:9094
advertised.listeners=SASL_PLAINTEXT://localhost:9094
security.inter.broker.protocol=SASL_PLAINTEXT
sasl.mechanism.inter.broker.protocol=PLAIN
sasl.enabled.mechanisms=PLAIN
zookeeper.connect=localhost:2181

```

and in the beggining of bin/zookeeper-server-start.sh add

```bash
# zookeeper-server-start.sh
export ZOOKEEPER_OPTS="-Djava.security.auth.login.config=$(pwd)/config/zookeeper-jaas.conf"

```

and for bin/kafka-server-start.sh

```bash
# kafka-server-start.sh
export KAFKA_OPTS="-Djava.security.auth.login.config=$(pwd)/config/kafka-server-jaas.conf"

```

### 4. Start zookeeper and all brokers

in different terminals run script

```bash
bin/zookeeper-server-start.sh config/zookeeper.properties //different terminal
bin/kafka-server-start.sh config/broker1.properties //diff terminal
bin/kafka-server-start.sh config/broker2.properties //diff terminal
bin/kafka-server-start.sh config/broker3.properties //diff terminal
```

### 5. Create new topic

create with name test-topic

```bash
bin/kafka-topics.sh   --create   --topic test   --bootstrap-server localhost:9092   --partitions 3   --replication-factor 2   --command-config config/producer.properties
```

and verify it

```bash
bin/kafka-topics.sh --describe --topic test --bootstrap-server localhost:9092 --command-config config/producer.properties
```

you can set wrong credentials for config/producer.properties and try to create and describe and see that authorization fails

### 6. Producer Consumer message test

make in 2 different terminals one consumer and one producer and connect to topic test-topic

```bash
bin/kafka-console-producer.sh --topic test --bootstrap-server localhost:9092 --producer.config config/producer.properties

```

```bash
bin/kafka-console-consumer.sh --topic test --bootstrap-server localhost:9092 --consumer.config config/consumer.properties --from-beginning
```

and send some messages

![img](../screenshots/task22.png)
![img](../screenshots/task23.png)

also you can change credentials in consumer.properties and producer.properties and try again
