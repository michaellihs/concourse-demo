#!/usr/bin/env bash

# 'web' is the service name for the Concourse web component in docker-compose
concourse_fqdn='web'

apt-get update
apt-get -y install curl

curl --noproxy ${concourse_fqdn} -s -f -o fly "http://${concourse_fqdn}:8080/api/v1/cli?arch=amd64&platform=linux"
chmod u+x fly

./fly --target=demo login \
    --concourse-url="http://${concourse_fqdn}:8080" \
    --username=test \
    --password=test \
    --team-name=main

for pipeline in $(ls -d demo-repo/tutorial* | xargs -n 1 basename); do

    if [[ "${pipeline}" != "tutorial-1" && "${pipeline}" != "tutorial-8" ]]; then
        if [[ -f "demo-repo/${pipeline}/settings.yml" ]]; then
            ./fly --target=demo set-pipeline \
                --non-interactive \
                --pipeline=${pipeline} \
                --load-vars-from=demo-repo/${pipeline}/settings.yml \
                --config=demo-repo/${pipeline}/pipeline.yml
        else
            ./fly --target=demo set-pipeline \
                --non-interactive \
                --pipeline=${pipeline} \
                --config=demo-repo/${pipeline}/pipeline.yml
        fi

        ./fly --target=demo unpause-pipeline -p ${pipeline}

    fi

done