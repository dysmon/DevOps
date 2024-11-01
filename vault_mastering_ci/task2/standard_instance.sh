#!/bin/bash

TRANSIT_IP=192.168.1.14
TOKEN=$1

sudo tee -a /etc/vault.d/vault.hcl <<EOF
seal "transit" {
  address    = "http://$TRANSIT_IP:8200"
  token      = "$TOKEN"
  key_name   = "unseal-key"
  mount_path = "transit"
}
EOF

sudo systemctl restart vault
sleep 3
vault operator init
