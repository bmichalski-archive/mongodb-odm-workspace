#!/usr/bin/env bash

PROJECT_NAME='mongodb-odm'

IP="0.0.0.0"

export SSH_PORT="$IP:2222" && \
export MONGO_PORT="27017" && \
docker-compose --project-name $PROJECT_NAME build && \
docker-compose --project-name $PROJECT_NAME up
