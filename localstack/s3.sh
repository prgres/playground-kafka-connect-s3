#!/usr/bin/env bash

_S3_BUCKET="${KAFKA_CONNECT_S3_BUCKET}"

awslocal s3 mb "s3://${_S3_BUCKET}"
