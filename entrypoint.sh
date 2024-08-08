#!/bin/sh

set -x
git config --global user.email ${GITHUB_USER_EMAIL}
git config --global user.name ${GITHUB_USERNAME}
git config --global user.password ${GITHUB_PASSWORD}

COMMAND=$1
WORKING_DIR="$5"

if [[ -z "${2}" || -z "${3}" || -z "${4}" ]]; then
  echo "One or more variables are not defined, will only run command"
else
  DOCKER_USERNAME=$2
  DOCKER_PASSWORD=$3
  DOCKER_REGISTRY=$4
  echo "Running docker login"
  [ -z "$DOCKER_REGISTRY" ] || echo "Using custom registry: ${DOCKER_REGISTRY}"
  docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD} ${DOCKER_REGISTRY}
fi

echo "Running command in ${WORKING_DIR}"
cd "$WORKING_DIR" || { echo "Cannot change into directory ${WORKING_DIR}"; exit 1; }
${COMMAND}
