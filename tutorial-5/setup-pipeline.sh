#!/usr/bin/env bash

concourse_fqdn='localhost'

../fly --target=demo login \
    --concourse-url="http://${concourse_fqdn}:8080" \
    --username=test \
    --password=test \
    --team-name=main

../fly --target=demo set-pipeline \
    --non-interactive \
    --pipeline=tutorial-5 \
    --load-vars-from=settings.yml \
    --config=pipeline.yml

../fly --target=demo unpause-pipeline -p tutorial-5
