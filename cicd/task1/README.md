
# GitLab Runner Management Scripts

This repository contains three Bash scripts to help you manage the installation, registration, and cleanup of GitLab Runner on your system.

## 1. `install_gitlab_runner.sh`

This script installs GitLab Runner and enables it to start automatically on system boot.

### Prerequisites:
- You need `sudo` privileges to run this script as it installs packages and enables services.

### Usage:

```bash
./install_gitlab_runner.sh
```

### What it does:
- Checks if the GitLab Runner repository is already added to your system.
- If not, it adds the GitLab Runner APT repository.
- Installs GitLab Runner if it's not already installed.
- Starts and enables the GitLab Runner service to start automatically on system boot.

## 2. `register_gitlab_runner.sh`

This script registers a GitLab Runner to a specific GitLab instance.

### Prerequisites:
- Ensure you have `jq` installed for parsing JSON responses.
- You need to add your valid `ACCESS_TOKEN` to ENV values to interact with the GitLab API.

### Usage:

```bash
./register_gitlab_runner.sh <url>
```

Where `<url>` is the GitLab instance URL (e.g., `https://gitlab.com/`).

### What it does:
- Registers a GitLab Runner non-interactively with the specified GitLab instance.
- Uses the generated runner token via GitLab API (you may need to update `ACCESS_TOKEN` and `group_id` in the script).
- Configures the runner to use the `shell` executor.

### Example:

```bash
./register_gitlab_runner.sh https://gitlab.com/
```

## 3. `clean.sh`

This script stops, unregisters, and removes the GitLab Runner from your system.

### Prerequisites:
- You need `sudo` privileges as it performs system-wide modifications.

### Usage:

```bash
./clean.sh
```

### What it does:
- Stops the GitLab Runner service.
- Unregisters all runners associated with the system.
- Removes GitLab Runner along with its configuration files.
- Deletes the `gitlab-runner` user.

