FROM confluentinc/cp-kafka-connect:7.0.1

WORKDIR /home/appuser
USER root
RUN yum -y update && yum -y upgrade

RUN chown appuser:root -R /etc/kafka /etc/${COMPONENT} /usr/logs /etc/schema-registry /usr/share/confluent-hub-components
RUN chown appuser:appuser -R /etc/confluent/docker

# --- INSTALLING CONNECTORS
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-s3:10.0.5

# https://www.confluent.io/hub/confluentinc/kafka-connect-datagen
# https://github.com/confluentinc/kafka-connect-datagen
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-datagen:0.5.3

# https://developer.confluent.io/learn-kafka/kafka-connect/docker/?utm_source=youtube&utm_medium=video&utm_campaign=tm.devx_ch.cd-kafka-connect-101_content.connecting-to-apache-kafka
CMD [ "/etc/confluent/docker/run" ]
