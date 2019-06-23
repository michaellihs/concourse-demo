#!/usr/bin/env bash

concourse_fqdn='localhost'

../fly --target=demo login \
    --concourse-url="http://${concourse_fqdn}:8080" \
    --username=test \
    --password=test \
    --team-name=main

for i in $(seq 1 7); do
    echo "delete pipeline tutorial-${i}"
    ../fly -t demo destroy-pipeline -n -p tutorial-${i}
done
