#!/bin/bash

vault secrets enable transit
vault write -f transit/keys/unseal-key

cat > /tmp/policy.hcl <<EOF
path "transit/encrypt/unseal-key" {
	capabilities = [ "update" ]
}
path "transit/decrypt/unseal-key" {
	capabilities = [ "update" ]
}
EOF

vault policy write unseal /tmp/policy.hcl
vault token create -policy=unseal

