# Kafka Perfoemance testing using build in kafka benchmarking

## Objective

Analyze Kafka performance by measuring producer and consumer throughput under various configurations. Adjust parameters such as batch.size, compression.type, producer modes, consumer commit modes, and the number of partitions.

## Prerequisites

1. Kafka Setup:

    Ensure your Kafka cluster is up and running in KRaft mode with SASL authentication.
    You have the Kafka binaries (e.g., kafka-producer-perf-test.sh, kafka-consumer-perf-test.sh) available in your Kafka directory.

2. Create a Topic:

    Create a topic to use for testing. Vary the number of partitions during tests.
    Example command:

```bash
bin/kafka-topics.sh --create --topic test-topic-[num of partitions] --partitions [num of desired partitions] --replication-factor 1 --bootstrap-server localhost:9092 --command-config config/producer.properties
```

Use the --command-config to include SASL authentication properties (client.properties file).

## Testing Producer Throughput

script to test the througput of producer:

```bash
bin/kafka-producer-perf-test.sh --topic test-topic --num-records 10000000 --record-size 100 --throughput -1 --producer-props bootstrap.servers=localhost:9092 batch.size=[size of batch] compression.type=[type of compression] acks=[type of acknowlegement] --producer.config config/producer.properties
```

1. `batch.size`: Test with values like `1`, `1000`, `10000`, `20000`.
2. `compression.type`: Test with `none`, `gzip`, `snappy`, `lz4`, `zstd`.
3. `acks`:`0` for fire and forget, Use `1` for async (leader), `all` or `-1` for sync.
and script to test the consumer througput:

```bash
bin/kafka-consumer-perf-test.sh --broker-list localhost:9092 --messages 10000000 --topic test-topic --consumer.config config/consumer.properties --group test-group
```

we need to change the `consumer.properties` to change the auto-commit mode of consumer:

```properties
enable.auto.commit=true // or false
```

1. `enable.auto.commit`:`false` or `true`

## Analysis

you can find all benchmark results in this exel sheets:
like batch_size.csv,compressors.csv etc.
- note:
   all tests was done with 1 million messages except consumer_mode benchmark

## Answers to questions

### 1 How did batch size affect throughput?

from the results we can see that batch size is not important for compression type `none` and only differs in other compression types.
With the greater batch size compressions work better because they compress smaller number of times.
but, Very large batch sizes can increase latency because the producer waits longer to accumulate messages before sending.

### 2 Which compression type gave the best performance and in which scenarious?

Zstd compression is supposedly the best option, with snappy being the best for low cpu usage, I think. Then lz4 and gzip are somewhere in the middle.

### 3 How did the producer mode impact throughput?

- Observation: asynchronous producer mode outperformed synchronous mode across all scenarios.
- Reason: asynchronous mode allows multiple requests to be sent without waiting for acknowledgments, thus reducing latency and increasing throughput.
  
### 4 How did the consumer commit mode affect throughput?

Asynchronous(auto.commit.enable=true) commit increases throughput due to reduced blocking and didnt require synchronous checks of data,witch is why it is fast but insecure for some services.
synchronous commits for scenarios requiring exact message processing once (e.g., financial transactions).

### 5 How did the number of partitions impact performance?

- Increasing the number of `partitions` with `brokers` allows Kafka to leverage more parallelism, improving producer and consumer throughput.
    1. Too few partitions:

        Limits parallelism and reduces throughput for high-volume topics.

    2. Too many partitions:

        Can lead to higher management overhead and slower consumer offset commits.

    3. Too many partitions and few brokers:

        Can lead to hight workload of brokers due to the many amounts of partitions

In our case we had 3 brokers and most optimal number of partitions was 3, and performance was lower when partitions was 8
