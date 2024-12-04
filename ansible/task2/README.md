
# Automating HashiCorp Nomad Installation and Configuration with Ansible

This repository contains an Ansible role to automate the process of installing and configuring HashiCorp Nomad. It includes tasks to install Nomad, configure it dynamically using a Jinja2 template for the `nomad.hcl` file, and set up Nomad to run as a systemd service.

## Prerequisites

- Ansible 2.9 or later
- Linux-based system (Ubuntu, CentOS, or Debian)
- Root or sudo access for installation tasks

## Installation

### Clone the Repository

Clone the repository to your local machine.

```bash
git clone https://github.com/dysmon/nomad-ansible.git
cd nomad-ansible
```

### Set Up Your Inventory

Create or update your Ansible inventory file (e.g., `inventory.ini`) to define the hosts where Nomad should be installed. You can include hosts like `nomad_server` and `nomad_client`:

```ini
[nomad_servers]
nomad-server1 ansible_host=192.168.1.10 ansible_user=your_user

[nomad_clients]
nomad-client1 ansible_host=192.168.1.11 ansible_user=your_user
```

### Run the Playbook

To execute the playbook and install Nomad on the specified hosts, run the following command:

```bash
ansible-playbook -i inventory.ini playbook.yml
```

This will install Nomad, configure it with the specified settings, and ensure the Nomad service is running and enabled.

## Role Structure

- **tasks/main.yml**: Contains tasks for installing and configuring Nomad.
- **templates/nomad.hcl.j2**: Jinja2 template for generating the Nomad configuration file (`nomad.hcl`).
- **templates/nomad.service.j2**: Jinja2 template for creating the systemd service file.
- **files/**: Contains any static files required by the role (e.g., installation scripts).
- **vars/main.yml**: Defines default values for variables.
- **defaults/main.yml**: Default values for variables that can be overridden.
- **meta/main.yml**: Metadata about the role, including dependencies.
- **README.md**: This file.

## Key Features

- **Dynamic Configuration**: The `nomad.hcl` configuration file is generated dynamically using a Jinja2 template based on the values defined in your inventory or host variables.
- **Systemd Service**: Nomad is configured to run as a systemd service, ensuring that the Nomad process is managed automatically by the system.
- **Support for Servers and Clients**: The role supports both Nomad servers and clients, with different configurations for each.

```

## Customization

- You can modify the default values in `vars/main.yml` or override them by defining them in your inventory or host-specific variable files.
- The `nomad.hcl.j2` template can be customized to suit your specific Nomad configuration needs.
- You can add additional tasks, handlers, or templates based on your infrastructure requirements.

## Troubleshooting

- Ensure that you have the correct permissions to execute the playbook with sudo privileges.
- Make sure that the target hosts are reachable via SSH, and that the necessary ports are open.
- Check the status of the Nomad service using the `systemctl` command if Nomad is not running correctly.

```bash
sudo systemctl status nomad
```

