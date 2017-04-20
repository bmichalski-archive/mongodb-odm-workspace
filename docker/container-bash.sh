#!/usr/bin/env bash

#Get current file parent directory
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

source $DIR/common.sh

#Try to guess if using docker-machine (for example on a Mac) or native Docker
if type "docker-machine" > /dev/null 2>&1; then
  #case when docker-machine is in use
  RUNNING_ON="docker-machine"
  DOCKER_MACHINE_IP=`docker-machine ip`
  SSH_PORT=$(docker-machine ssh default "docker inspect --format '{{index .NetworkSettings.Ports \"22/tcp\" 0 \"HostPort\" }}' \"$PHP_CONTAINER_NAME\"")
else
  #case when native docker is in use
  RUNNING_ON="native"
  DOCKER_MACHINE_IP=127.0.0.1
  SSH_PORT=$(docker inspect --format '{{index .NetworkSettings.Ports "22/tcp" 0 "HostPort" }}' "$PHP_CONTAINER_NAME")
fi

function createDockerExecCommand {
  echo "docker exec -t \"$1\" bash -c \"$2\""
}

function dockerExec() {
  if [ "$RUNNING_ON" == "docker-machine" ]
  then
    docker-machine ssh default $(createDockerExecCommand "$1" "$2")
  else
    eval $(createDockerExecCommand "$1" "$2")
  fi
}

ID_RSA_PUB=$(cat ~/.ssh/id_rsa.pub) && \
CREATE_DOT_SSH_DIR_CMD="mkdir -p /home/r/.ssh" && \
CREATE_AUTHORIZED_KEYS_CMD="echo '$ID_RSA_PUB' > /home/r/.ssh/authorized_keys" && \
CHOWN_DOT_SSH_DIR_CMD="chown -R r:r /home/r/.ssh" && \
MKDIR_DBAL_DIR_CMD="mkdir -p /home/r/mongodb-odm" && \
CHOWN_DBAL_DIR_CMD="chown r:r /home/r/mongodb-odm" && \
CREATE_SUDO_AS_ADMIN_SUCCESS_FILE="touch /home/r/.sudo_as_admin_successful" && \
dockerExec "$PHP_CONTAINER_NAME" "$CREATE_DOT_SSH_DIR_CMD" && \
dockerExec "$PHP_CONTAINER_NAME" "$CREATE_AUTHORIZED_KEYS_CMD" && \
dockerExec "$PHP_CONTAINER_NAME" "$CHOWN_DOT_SSH_DIR_CMD" && \
dockerExec "$PHP_CONTAINER_NAME" "$MKDIR_DBAL_DIR_CMD" && \
dockerExec "$PHP_CONTAINER_NAME" "$CHOWN_DBAL_DIR_CMD" && \
dockerExec "$PHP_CONTAINER_NAME" "$CREATE_SUDO_AS_ADMIN_SUCCESS_FILE" && \
ssh \
  -p $SSH_PORT \
  -o StrictHostKeyChecking=no \
  -o UserKnownHostsFile=/dev/null \
  -t \
  r@$DOCKER_MACHINE_IP \
  "cd /home/r; cd /home/r/mongodb-odm; bash"

