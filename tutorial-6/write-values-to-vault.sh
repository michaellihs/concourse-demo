#!/usr/bin/env bash

# When resolving a parameter such as ((foo_param)), Concourse will look in the following paths, in order:
#
#   /concourse/TEAM_NAME/PIPELINE_NAME/foo_param
#
#   /concourse/TEAM_NAME/foo_param
write_vault() {
    path=$1
    key=$2
    secret=$3

    docker exec -it concourse-demo_vault_1 /bin/sh -c "vault kv put -tls-skip-verify concourse/${path} ${key}=${secret}"
}


write_vault "main/tutorial-6/vault-param-1" "val" "secret-1"
write_vault "main/tutorial-6/vault-param-2" "value" "secret-2"
