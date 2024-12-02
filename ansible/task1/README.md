
# Ansible User Management Playbooks

This project contains Ansible playbooks to automate the creation and deletion of users on a remote server. It also includes SSH key generation for newly created users to enable key-based authentication.

## Prerequisites

- Ansible installed on the local machine
- SSH access to the remote server
- A user with `sudo` privileges on the remote server
- The `ansible_user` specified in the inventory file

## Inventory File

### `inventory.yml`

The inventory file defines the remote server details for Ansible to connect to. An example is shown below:

```ini
[web-server]
web-server ansible_host= ansible_connection=ssh ansible_user= ansible_become_password=
```

- **`ansible_host`**: The IP address of the remote server.
- **`ansible_connection=ssh`**: The connection method, which is SSH in this case.
- **`ansible_user`**: The user Ansible will use to connect to the server.
- **`ansible_become_password`**: The password for the `ansible_user` to allow `sudo` privileges.

## Playbooks

### 1. User Creation Playbook

#### `create_users.yml`

This playbook creates users on the remote server and generates an SSH key pair for each new user. The playbook can be customized by modifying the `loop` to add or remove users as needed.

```yaml
- name: Play for creating users
  hosts: web-server
  become: true
  tasks:
    - name: Creating user '{{ item }}'
      ansible.builtin.user:
        name: '{{ item }}'
        create_home: true
        state: present
        generate_ssh_key: true
      loop:
        - john
        - james
        - johan
```

**Parameters:**
- **`create_home: true`**: Ensures that a home directory is created for the new user.
- **`state: present`**: Ensures the user exists on the server.
- **`generate_ssh_key: true`**: Automatically generates an SSH key pair for the new user.

### 2. User Deletion Playbook

#### `delete_users.yml`

This playbook removes users from the remote server. A safeguard is included to prevent the deletion of the user running the playbook.

```yaml
- name: Play for deleting users
  hosts: web-server
  become: true
  tasks:
    - name: Deleting user - '{{ item }}'
      ansible.builtin.user:
        name: '{{ item }}'
        state: absent
        remove: true
      when: item != ansible_user
      loop:
        - john
        - james
        - johan
```

**Parameters:**
- **`state: absent`**: Ensures the user is deleted from the server.
- **`remove: true`**: Removes the user’s home directory and files.
- **`when: item != ansible_user`**: Prevents the user running the playbook from being deleted.

### 3. Key Management

- The SSH keys for each user are generated automatically and stored in the home directory of the user.
- The keys are also displayed in the console during the user creation process for future use.

## Running the Playbooks

### 1. Create Users

To run the `create_users.yml` playbook and create the users `john`, `james`, and `johan`, execute the following command:

```bash
ansible-playbook -i inventory.yml create_users.yml
```

### 2. Delete Users

To run the `delete_users.yml` playbook and remove the users `john`, `james`, and `johan` (except the user running the playbook), execute the following command:

```bash
ansible-playbook -i inventory.yml delete_users.yml
```

## Troubleshooting

1. **Missing sudo password**: If you encounter an error regarding a missing sudo password, ensure that `ansible_become_password` is set correctly in the inventory file.
2. **SSH key generation failure**: Ensure that the target machine allows SSH key generation and that you have proper permissions.
