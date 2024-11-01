#!/bin/bash

VAULT_CONFIG="/etc/vault.d/vault.hcl"

install_vault() {
	if [ ! -f /usr/share/keyrings/hashicorp-archive-keyring.gpg ]; then 
		sudo wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
		echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
	fi
	if ! dpkg -l | grep -q vault; then
		sudo apt update && sudo apt install vault
	fi
}

configure_vault() {
#################################################################
############## VAULT CONFIG ###################################
sudo tee ${VAULT_CONFIG} <<EOF
ui             = true
#api_addr       = "http://0.0.0.0:8200"
#mlock         = true
#disable_mlock = true

storage "file" {
  path = "/opt/vault/data"
}

listener "tcp" {
  address = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8200"
  tls_disable = 1
}
EOF

export VAULT_ADDR="http://127.0.0.1:8200"

#################################################################
############## SYSTEMD VAULT ###################################
if [ ! -f /etc/systemd/system/vault.service ]; then
sudo tee /etc/systemd/system/vault.service <<EOF
[Unit]
Description=HashiCorp Vault - A tool for managing secrets
Requires=network-online.target
After=network-online.target

[Service]
User=vault
Group=vault
ExecStart=/usr/bin/vault server -config=${VAULT_CONFIG}
ExecReload=/bin/kill --signal HUP $MAINPID
LimitMEMLOCK=infinity
Restart=on-failure
RestartSec=5
KillSignal=SIGINT
TimeoutStopSec=30
KillMode=process

[Install]
WantedBy=multi-user.target
sudo systemctl daemon-reload
sudo systemctl enable vault
EOF
fi

sudo systemctl restart vault
sleep 1 
}

initialize_vault() {
	if [[ $(vault status | grep Initialized | grep false) ]]; then
		echo "Initializing Vault..."
		output=$(vault operator init -format=json)

		# Extract unseal keys and root token
		echo "${output}" | jq -r '.unseal_keys_b64[]' > unseal_keys.txt
		echo "${output}" | jq -r '.root_token' > root_token.txt

		# Secure the files
		sudo chown vault:vault unseal_keys.txt
		sudo chmod 600 unseal_keys.txt root_token.txt
		echo "Vault initialized. Unseal keys and root token stored securely."
	fi
}

unseal_vault() {
	echo "Unsealing Vault..."
	sudo cat ./unseal_keys.txt | while IFS= read -r key; do
    	vault operator unseal "$key"
    done

}

# Main
install_vault
configure_vault
initialize_vault
unseal_vault

echo "Vault installation and configuration completed. ROOT token and UNSEAL tokens stored in the current directory"
echo "provide enviroment vars 'VAULT_ADDR' and 'VAULT_TOKEN' to use vault commands"
