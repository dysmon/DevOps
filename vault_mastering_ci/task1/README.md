# Vault Setup Script

This script automates the installation, configuration, initialization, and unsealing of HashiCorp Vault on a Debian-based system.

## Features

- Installs Vault
- Configures Vault
- Initializes Vault
- Unseals Vault
- Stores unseal keys and root token securely

## Prerequisites

- Debian-based system (e.g., Ubuntu)
- `sudo` privileges
- Internet connection

## Usage

1. Make the script executable:
   ```
   chmod +x vault_setup.sh
   ```

2. Run the script:
   ```
   sudo ./vault_setup.sh
   ```

## What the Script Does

1. **Install Vault**
   - Adds HashiCorp's GPG key
   - Adds HashiCorp's repository to apt sources
   - Installs Vault

2. **Configure Vault**
   - Creates a Vault configuration file at `/etc/vault.d/vault.hcl`
   - Sets up Vault to use file storage at `/opt/vault/data`
   - Configures Vault to listen on all interfaces (0.0.0.0) on port 8200
   - Disables TLS (Note: Enable TLS for production use)

3. **Set Up Systemd Service**
   - Creates a systemd service file for Vault
   - Enables and starts the Vault service

4. **Initialize Vault**
   - Initializes Vault if not already initialized
   - Stores unseal keys in `unseal_keys.txt`
   - Stores root token in `root_token.txt`

5. **Unseal Vault**
   - Automatically unseals Vault using the generated unseal keys

## Important Notes

- The script disables TLS for Vault. Enable TLS for production use.
- Unseal keys and root token are stored in the current directory. Secure these files appropriately.
- Set the `VAULT_ADDR` and `VAULT_TOKEN` environment variables to use Vault commands after setup.

## Security Considerations

- The unseal keys and root token are sensitive. Ensure they are stored securely and not exposed to unauthorized parties.
- For production use, consider implementing a more secure method of unsealing Vault, such as using Vault's auto-unseal feature.

## Customization

You can modify the `VAULT_CONFIG` variable in the script to customize Vault's configuration according to your needs.

## License

This script is provided as-is, without any warranty. Use at your own risk.
