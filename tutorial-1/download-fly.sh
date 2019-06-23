#!/usr/bin/env bash

concourse_fqdn='localhost'

curl --noproxy ${concourse_fqdn} -s -f -o ../fly "http://${concourse_fqdn}:8080/api/v1/cli?arch=amd64&platform=darwin"
chmod u+x ../fly

../fly --target=demo login \
    --concourse-url="http://${concourse_fqdn}:8080" \
    --username=test \
    --password=test \
    --team-name=main
