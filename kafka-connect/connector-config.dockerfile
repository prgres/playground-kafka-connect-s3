FROM alpine:latest

WORKDIR /

RUN apk update
RUN apk upgrade
RUN apk add wget curl bash

RUN wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
    mv jq-linux64 /usr/local/bin/jq && \
    chmod +x /usr/local/bin/jq

COPY ./scripts.d/entrypoint.sh /entrypoint.sh
COPY ./connectors.d /connectors.d

ENTRYPOINT [ "/entrypoint.sh" ]
