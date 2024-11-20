#!/bin/bash

create_topics() {
  for file in jsons/topics.json; do
    jq -c '.[]' "$file" | while read topic; do
      topic_name=$(echo "$topic" | jq -r .topic_name)
      partitions=$(echo "$topic" | jq -r .partitions)
      replication_factor=$(echo "$topic" | jq -r .replication_factor)
      delete_policy=$(echo "$topic" | jq -r .delete_policy)

      echo "Creating topic: $topic_name with $partitions partitions, $replication_factor replication factor, delete policy: $delete_policy"
      $KAFKA_BIN_DIR/kafka-topics.sh --create --topic "$topic_name" --partitions "$partitions" --replication-factor "$replication_factor" --config "cleanup.policy=$delete_policy" --bootstrap-server localhost:9092 --command-config $KAFKA_CONFIG_DIR/producer.properties
    done
  done
}

delete_topics() {
  for file in jsons/delete_topics.json; do
    jq -c '.[]' "$file" | while read topic; do
      topic_name=$(echo "$topic" | jq -r .topic_name)

      echo "Deleting topic: $topic_name"
      $KAFKA_BIN_DIR/kafka-topics.sh --delete --topic "$topic_name" --bootstrap-server localhost:9092 --command-config $KAFKA_CONFIG_DIR/producer.properties
    done
  done
}

apply_permissions() {
  for file in jsons/user_permissions.json; do
    jq -c '.[]' "$file" | while read -r user_permission; do
      user=$(echo "$user_permission" | jq -r .user)
      topic_name=$(echo "$user_permission" | jq -r .topic_name)
      permissions=$(echo "$user_permission" | jq -r '.permissions[]') 

      for permission in $permissions; do
        echo "Applying permission: $permission for user: $user on topic: $topic_name"
        $KAFKA_BIN_DIR/kafka-acls.sh --bootstrap-server localhost:9092 --add --allow-principal User:$user --operation $permission --topic $topic_name --command-config $KAFKA_CONFIG_DIR/producer.properties
      done
    done    
  done
}

create_topics
delete_topics
apply_permissions
$KAFKA_BIN_DIR/kafka-acls.sh --bootstrap-server localhost:9092 --list --topic my_topic_1 --command-config $KAFKA_CONFIG_DIR/producer.properties
$KAFKA_BIN_DIR/kafka-topics.sh --bootstrap-server localhost:9092 --list --command-config $KAFKA_CONFIG_DIR/producer.properties
echo "Deployment successful!"
exit 0
