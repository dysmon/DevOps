
# Viper: Docker Image Cleanup Script

This project provides a script (`viper.sh`) that automatically cleans up unused Docker images based on their last usage date. The script identifies unused images, removes them, logs the cleanup activities, and sends a notification email with the details.

## Prerequisites

1. **Docker**: Ensure Docker is installed and running on your system.

2. **Email Configuration**: You need to set up email configuration for sending notifications after the cleanup. This is done using **mailutils** and **ssmtp**.
   - Follow this guide for configuring email: [SMTP Mailutils Setup Guide](https://medium.com/@FlorenceOkoli/smtp-mailutils-how-to-send-your-mails-via-the-linux-terminal-6d95803a1104)
   
3. **Systemd**: The script uses a `systemd` service and timer for periodic execution. Ensure `systemd` is available on your system.

## Installation

1. Clone the repository or copy the script files to your working directory.

```bash
git clone https://your-repo-link.git
cd your-repo-directory
```

2. Modify the `viper.sh` script if needed:
   - Set the correct email address for receiving notifications.
   - Customize any other configurations.

3. Run the setup script `setup_viper.sh` to create the systemd service and timer.

```bash
./setup_viper.sh
```

## How It Works

- The `viper.sh` script performs the following tasks:
  1. Scans running containers and logs the image IDs with their last usage time.
  2. Creates `viper_journal.sh` and writes there last usage of images
  3. Removes Docker images that have not been used for more than 30 days.
  4. Logs the cleanup activity in `viper_logs`.
  5. Sends an email notification with the list of deleted images.

- The systemd timer is configured to run the script every minute.

## Logs

The script writes logs to the `viper_logs` file in your working directory. Each log entry includes the image ID and the time of deletion.

## Email Notifications

After each cleanup, an email is sent to notify about the removed images. Make sure your email configuration is set up correctly as per the prerequisites.
