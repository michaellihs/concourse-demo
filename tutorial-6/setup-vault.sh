#!/usr/bin/env bash

# see https://github.com/hashicorp/best-practices/blob/master/packer/config/vault/scripts/setup_vault.sh

cleanup() {
    shred /tmp/vault-keys
}

trap cleanup INT TERM QUIT EXIT


# Initialize Vault
docker exec -it demo_vault_1 /bin/sh -c 'export VAULT_CACERT=/vault/certs/vault-ca.crt; /bin/vault operator init -key-shares=1 -key-threshold=1 -format=json' > /tmp/vault-keys

# Unseal Vault and login with root token (EVIL!!!)
unseal_key=$(cat /tmp/vault-keys | jq -r '.unseal_keys_b64[0]')
login_token=$(cat /tmp/vault-keys | jq -r '.root_token')

echo "Unseal Key: ${unseal_key}"
echo "Login Token: ${login_token}"

docker exec -it demo_vault_1 /bin/sh -c "export VAULT_CACERT=/vault/certs/vault-ca.crt; /bin/vault operator unseal -tls-skip-verify ${unseal_key}"
docker exec -it demo_vault_1 /bin/sh -c "export VAULT_CACERT=/vault/certs/vault-ca.crt; /bin/vault login -tls-skip-verify '${login_token}'"

# Enable cert-based authentication in Vault
docker exec -it demo_vault_1 /bin/sh -c "export VAULT_CACERT=/vault/certs/vault-ca.crt; /bin/vault auth enable cert"
docker exec -it demo_vault_1 /bin/sh -c "export VAULT_CACERT=/vault/certs/vault-ca.crt; /bin/vault write auth/cert/certs/concourse policies=concourse certificate=@/vault/certs/vault-ca.crt ttl=1h"


# Write Vault policy to enable read access for Concourse
docker exec -it demo_vault_1 /bin/sh -c "export VAULT_CACERT=/vault/certs/vault-ca.crt; /bin/vault policy write concourse /vault/config/concourse-policy.hcl"

# Create K/V store for Concourse credentials
docker exec -it demo_vault_1 /bin/sh -c "vault secrets enable -version=1 -path=concourse -tls-skip-verify kv"
