#!/bin/bash

#Get current file parent directory
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

#Defined
PROJECT_NAME='mongodbodm'

PHP_CONTAINER_NAME=$PROJECT_NAME'_php_1'

#Computed
FOLDERS=$REPOSITORIES
DOCKER_DEV_REPOSITORY_FULLPATH=$DIR/$DOCKER_DEV_REPOSITORY_SHORTNAME
