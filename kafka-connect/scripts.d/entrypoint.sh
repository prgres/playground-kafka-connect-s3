#!/usr/bin/env bash

URL="http://${CONNECT_HOST_NAME}:${CONNECT_REST_PORT}/connectors"

echo "Waiting for Kafka Connect to start listening on localhost ⏳"

while : ; do
    curl_status=$(curl -s -o /dev/null -w %{http_code} --max-time 30 "${URL}" )
    echo " Kafka Connect listener HTTP state: " $curl_status
    if [ $curl_status -eq 200 ] ; then
        break
    fi
    
    sleep 15
done
echo "Kafka Connect started"


for CONFIG_FILEPATH in ./connectors.d/*.properties; do
    CONFIG_NAME=$( basename ${CONFIG_FILEPATH} .properties )
    
    CONNECTOR_CONFIG=$( cat  "${CONFIG_FILEPATH}" | jq -R -s 'split("\n") | map(select(length > 1)) | map(select(startswith("#") | not)) | map(split("=")) | map({(.[0]): .[1]}) | add' )
    
    CONNECTOR_CONFIG=$( echo "${CONNECTOR_CONFIG}" | jq ". += {\"name\": \""${CONFIG_NAME}"\"}" )
    CONNECTOR_CONFIG=$( echo "${CONNECTOR_CONFIG}" | jq ". += {\"s3.bucket.name\": \""${S3_CONN_BUCKET_NAME}"\"}" )
    CONNECTOR_CONFIG=$( echo "${CONNECTOR_CONFIG}" | jq ". += {\"store.url\": \""${S3_CONN_STORE_URL}"\"}" )
    # CONNECTOR_CONFIG=$( echo "${CONNECTOR_CONFIG}" | jq ". += {\"key.converter.schema.registry.url\": \""${SCHEMA_REGISTRY_URL}"\"}" )
    # CONNECTOR_CONFIG=$( echo "${CONNECTOR_CONFIG}" | jq ". += {\"value.converter.schema.registry.url\": \""${SCHEMA_REGISTRY_URL}"\"}" )
    
    
    echo "${CONNECTOR_CONFIG}"
    
    echo -e "\n--\n+> Creating Data Generator source"
    echo curl -s -X PUT -H  "Content-Type:application/json" "http://${CONNECT_HOST_NAME}:${CONNECT_REST_PORT}/connectors/${CONFIG_NAME}/config" -d "${CONNECTOR_CONFIG}"
    curl -s -X PUT -H  "Content-Type:application/json" "http://${CONNECT_HOST_NAME}:${CONNECT_REST_PORT}/connectors/${CONFIG_NAME}/config" -d "${CONNECTOR_CONFIG}"
done

echo "Kafka connect S3 sink configs loaded"
# while sleep 3600; do :; done

#     -d '{
#     "connector.class": "io.confluent.kafka.connect.datagen.DatagenConnector",
#     "key.converter": "org.apache.kafka.connect.storage.StringConverter",
#     "kafka.topic": "ratings",
#     "max.interval":750,
#     "quickstart": "ratings",
#     "tasks.max": 1
# }'
