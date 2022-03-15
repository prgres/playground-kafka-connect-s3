FROM confluentinc/cp-kafka-connect:6.0.1

WORKDIR /home/appuser

# --- INSTALLING CONNECTORS
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-s3:10.0.5

# --- ENVS
ENV CONNECT_GROUP_ID=kafka-connect

ENV CONNECT_CONFIG_STORAGE_TOPIC=kafka-connect-config
ENV CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR=2

ENV CONNECT_OFFSET_STORAGE_TOPIC=kafka-connect-offset
ENV CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR=2

ENV CONNECT_STATUS_STORAGE_TOPIC=kafka-connect-status
ENV CONNECT_STATUS_STORAGE_REPLICATION_FACTOR=2

ENV CONNECT_KEY_CONVERTER=io.confluent.connect.avro.AvroConverter
ENV CONNECT_VALUE_CONVERTER=io.confluent.connect.avro.AvroConverter

ENV CONNECT_LOG4J_ROOT_LOGLEVEL=DEBUG
ENV CONNECT_LOG4J_LOGGERS=org.apache.kafka.connect.runtime.rest=INFO,org.reflections=ERROR

ENV CONNECT_PLUGIN_PATH=/usr/share/java,/usr/share/confluent-hub-components

# Kafka Connect UI
ENV CONNECT_ACCESS_CONTROL_ALLOW_METHODS='GET,POST,PUT,DELETE,OPTIONS'
ENV CONNECT_ACCESS_CONTROL_ALLOW_ORIGIN='*'

# --- ENTRYPOINT
# COPY entrypoint.sh .

ENTRYPOINT [ "/etc/confluent/docker/run" ]
