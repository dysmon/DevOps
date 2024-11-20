# TASK1 of kafka

Implement a system where changes to Kafka topics (creation and deletion) can be
proposed through merge requests.
Developers should be able to specify the following parameters in their requests
o Topic name
o Partitions
o Replication factor
o Delete policy
Add functionality for developers to propose changes to Kafka user permissions, also
through merge requests. Developers should be able to specify which users or
services have read, write, or admin rights to specific topics.
Prepare a GitLab CI/CD pipeline that should have at least two stages
1. Validate - validate the syntax and correctness of the proposed Kafka topic
and user configuration files
2. Deploy – apply the changes to the Kafka instance after merge request is
approved and merged
Your documentation should include details like
- How to setup the development environment
- How to create and submit merge requests for Kafka topic and permission
changes
- An overview of the CI/CD pipeline process
- An example with demonstration of the pipeline executing a sample merge
request that creates or deletes topic and modifies user permissions
## Instructions

All the enviroment creating activities are located in .gitlab-ci.yml and will run automaticaly when merged

### 1. Clone repository

```bash
git clone https://gitlab.com/devops6553738/kafka.git
cd kafka
```
### 2. Branching 
```bash
git branch "name"
git checkout "name"
```
### 2. Changes

Change json files in dir `jsons/` to create the topic or delete it and manage permissions of users to some topic

for example, you can create topics by writing in file `jsons/topics.json`
```json
[
  {
    "topic_name": "my_topic_beka",
    "partitions": 3,
    "replication_factor": 2,
    "delete_policy": "delete"
  },
  {
    "topic_name": "my_topic_zhans",
    "partitions": 5,
    "replication_factor": 3,
    "delete_policy": "compact"
  },
  {
    "topic_name": "my_topic_aizada",
    "partitions": 5,
    "replication_factor": 3,
    "delete_policy": "compact"
  }
]
```

and delete topic in `jsons/delete_topics.json`

```json
[
    {
      "topic_name": "my_topic_aizada"
    }
]
```
and manage permissions with `json/user_permissions.json`
```json

```