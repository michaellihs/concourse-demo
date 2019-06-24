#!/usr/bin/env bash

set -u

vars_file=$(mktemp /tmp/setup-pipeline.XXXXXX)

cleanup() {
    rm -rf vars_file
}

# make sure expected variables are set, before we do anything
CONCOURSE_FQDN="localhost"
CONCOURSE_USER="test"
CONCOURSE_PASSWORD="test"
DOCKER_REPO=michaellihs
DOCKER_USER=michaellihs
DOCKER_PASSWORD=${DOCKER_PASSWORD}

PIPELINE_NAME='tutorial-7'

trap cleanup INT TERM QUIT EXIT

cat <<EOF > ${vars_file}
docker_repo: ${DOCKER_REPO}
docker_user: ${DOCKER_USER}
docker_password: ${DOCKER_PASSWORD}
EOF

../fly --target=concourse login \
    --concourse-url="http://${CONCOURSE_FQDN}:8080" \
    --username=${CONCOURSE_USER} \
    --password=${CONCOURSE_PASSWORD} \
    --team-name=main

../fly --target=concourse set-pipeline \
    --non-interactive \
    --pipeline=${PIPELINE_NAME} \
    --load-vars-from=${vars_file} \
    --config=pipeline.yml

../fly --target=rocket-notify unpause-pipeline -p ${PIPELINE_NAME}
