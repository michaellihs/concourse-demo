#!/usr/bin/env bash

pipeline_namespace='concourse'

write_vault() {
    path=$1
    key=$2
    secret=$3

    docker exec -it demo_vault_1 /bin/sh -c "vault kv put -tls-skip-verify ${pipeline_namespace}/${path} ${key}=${secret}"
}

# When resolving a parameter such as ((foo_param)), Concourse will look in the following paths, in order:
#
#   /concourse/TEAM_NAME/PIPELINE_NAME/foo_param
#
#   /concourse/TEAM_NAME/foo_param


docker exec -it demo_vault_1 /bin/sh -c "vault secrets enable -version=1 -path=${pipeline_namespace} -tls-skip-verify kv"

write_vault "main/tutorial-8/vault-param-1" "key" "secret-1"
write_vault "main/tutorial-8/vault-param-2" "key" "secret-2"
