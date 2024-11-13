# Auto-Transit Vault Setup

This project provides scripts for setting up a Vault cluster using the Transit secret engine for auto-unsealing. It consists of two main components:

1. Transit Vault Instance (`transit_instance.sh`)
2. Standard Vault Instance (`standard_instance.sh`)

## Prerequisites

- HashiCorp Vault installed on all instances
- Bash shell
- `sudo` privileges on all instances
- Network connectivity between instances

## Setup Instructions

### 1. Transit Vault Instance

This instance will serve as the key management system for auto-unsealing other Vault instances.

1. Copy `transit_instance.sh` to your Transit Vault server.
2. Make the script executable:
   ```
   chmod +x transit_instance.sh
   ```
3. Run the script:
   ```
   ./transit_instance.sh
   ```

The script will:
- Enable the Transit secrets engine
- Create a new key for unsealing
- Set up a policy for encrypting and decrypting data
- Create a token with the "unseal" policy

**Important:** Make note of the token generated at the end of this script. You'll need it for the standard instances.

### 2. Standard Vault Instance

This script sets up a Vault instance that uses the Transit Vault for auto-unsealing.

1. Copy `standard_instance.sh` to each of your standard Vault servers.
2. Make the script executable:
   ```
   chmod +x standard_instance.sh
   ```
3. Run the script, providing the token from the Transit Vault setup:
   ```
   ./standard_instance.sh <TOKEN>
   ```
   Replace `<TOKEN>` with the actual token generated in the Transit Vault setup.

The script will:
- Configure the Vault instance to use Transit seal
- Restart the Vault service
- Initialize the Vault instance

## Usage

After running both scripts:

1. The Transit Vault instance will be set up to manage unsealing keys.
2. Each standard Vault instance will be configured to auto-unseal using the Transit Vault.
3. You can now use the standard Vault instances normally, and they will automatically unseal on restart.

## Important Notes

1. **Security:** The token used for the Transit seal is highly sensitive. Ensure it's stored securely and not exposed in logs or to unauthorized personnel.

2. **Network Security:** Ensure that the network between the Transit Vault and standard Vault instances is secure. Consider using TLS for all communications.

3. **IP Address:** The `standard_instance.sh` script uses a hardcoded IP address (192.168.1.14) for the Transit Vault. Update this in the script if your Transit Vault has a different IP.

4. **Vault Configuration:** This setup modifies the Vault configuration file. Ensure you have backups of your original configuration.

5. **Production Use:** Before using this setup in production, review HashiCorp's best practices for Vault deployment and consider additional security measures.

6. **Initialization:** The `standard_instance.sh` script initializes the Vault. Make sure to securely store the root token and recovery keys generated during this process.

## Troubleshooting

If you encounter issues:

1. Check Vault logs: `sudo journalctl -u vault`
2. Verify Vault status: `vault status`
3. Ensure network connectivity between instances
4. Verify the Transit Vault token is correct and has the necessary permissions

## License

This project is provided as-is, without any warranty. Use at your own risk.
