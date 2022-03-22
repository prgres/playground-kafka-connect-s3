# playground-kafka-connect-s3

Playground with Kafka with S3 bucket connect enviroment. The setup bootstraps kafka cluster with 3 nodes, zookeeper cluster, and schemaregistry.



Futhermore
## How to run locally?

`make docker` - docker will handle the rest

## Containers

### KAFKA-CONNECT
```
Kafka Connect is a free, open-source component of Apache Kafka® that works as a centralized data hub for simple data integration between databases, key-value stores, search indexes, and file systems
```

[More about kafka connect on Confluent docs](https://docs.confluent.io/platform/current/connect/index.html#:~:text=Kafka%20Connect%20is%20a%20free,Kafka%20Connect%20for%20Confluent%20Platform)

There are 2 Kafka Connect connectors:
- [`kafka-connect-datagen`](https://github.com/confluentinc/kafka-connect-datagen) - supplies data
- [`Amazon S3 Sink Connector`](https://www.confluent.io/hub/confluentinc/kafka-connect-s3) - sends these data to the S3 bucket.

### KAFKA-CONNECT-CONNECTOR-CONFIG
`Kafka-connect` needs to be configured to properly create those connectors. I have created custom
provisioning solution for that. The `kafka-connect-connector-config` containers waits for `kafka-connect` to be ready and then makes HTTP request for each config file in `./kafka-connect/connectors.d` directory.

### AKHQ
This playground comes with [akhq](https://akhq.io) for cluster monitoring and kafka managed.

### LOCALSTACK
For playground purpose, everything occurs in local environemt so you do not need AWS account - [localstack](https://github.com/localstack/localstack) provides us S3 bucket mock.

```
    volumes:
    ...
    - ./localstack:/docker-entrypoint-initaws.d
```

It mounts the `./localstack` dir into `docker-entrypoint-initaws.d`. Basicly it allow us to create resources like S3 bucket. Inside of `./localastack/s3.sh` you can find `awslocal` command.
It is just a tiny wrapper around the regular aws cli with builtin flag `--endpoint`.

### AWSCLI
The `awscli` container with play-ready solution for interacting with `localstack`. Entrypoint `[ /bin/bash, -c, while true; do sleep 30; done; ]` means that it does nothing on its own. Just starts and waits for you connect. To use this you need to `docker exec -it <container_id> /bin/bash` and add `--endpoint=${AWS_ENDPOINT}` to you your awscli command. This tells cli to connect to `localstack` infrastruce instead of Amazon. Beside that you can use awscli like a regular one.

For example:
```
$ aws --endpoint=${AWS_ENDPOINT} s3 ls
```

Otherwise, it can be safety removed.
