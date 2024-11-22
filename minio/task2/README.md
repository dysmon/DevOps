
# MinIO Synchronization Script

This script synchronizes data between a local directory and a MinIO bucket. It ensures that the bucket is created (if not already present), and configures the synchronization to run every minute using a cron job.

## Prerequisites

Before running the script, ensure that the following are set up:

1. **MinIO**: MinIO should be running on your local system and accessible via the configured endpoint (e.g., `http://localhost:9001`).

## Script Overview

The script performs the following steps:
1. **Installs `rclone`** (if not installed).
2. **Sets up an `rclone` configuration** to connect to the MinIO instance using your provided access and secret keys.
3. **Adds a cron job** to synchronize the local directory (`$HOME_DIR/data/`) with the MinIO bucket (`my-bucket`) every minute.

## Requirements

- Linux-based OS (tested on Ubuntu).
- Docker running MinIO (or a locally available MinIO server).
- `curl` and `cron` should be installed on the system.

## Installation

1. Clone or download this repository to your local machine.

2. Make the script executable:

   ```bash
   chmod +x sync_minio.sh
   ```

3. Run the script to set up synchronization:

   ```bash
   ./sync_minio.sh
   ```

   This will:
   - Install `rclone` if it's not installed.
   - Create an `rclone` configuration file to connect to MinIO.
   - Add a cron job that synchronizes the specified local directory with the MinIO bucket every minute.

## Script Details

### Variables:
- `ACCESS_KEY`: MinIO access key.
- `SECRET_KEY`: MinIO secret key.
- `ENDPOINT`: The endpoint where MinIO is running (e.g., `http://localhost:9001`).
- `BUCKET_NAME`: The name of the MinIO bucket (e.g., `my-bucket`).
- `HOME_DIR`: The path to the local directory to sync.

### Cron Job:
- The cron job is set to run the synchronization every minute using the command:
  ```bash
  rclone sync /home/dias/data/ minio:my-bucket
  ```

## Troubleshooting

- **Rclone installation**: If the script fails to install `rclone`, ensure that your system has `curl` installed and that your internet connection is working.
- **MinIO Configuration**: Double-check the MinIO endpoint, access key, and secret key to ensure they are correct and that MinIO is running.
- **Permissions**: Ensure that the script has the necessary permissions to write the configuration file and add the cron job.

## Additional Configuration

- You can modify the `HOME_DIR` and `BUCKET_NAME` variables in the script to fit your own setup.
- If you need to change the sync interval, modify the cron job configuration. The current script sets the synchronization to run every minute (`* * * * *`).

## Conclusion

This script simplifies the process of setting up synchronization between your local directory and a MinIO bucket, and automates the synchronization with a cron job that runs every minute.

For more information on `rclone`, refer to the [official documentation](https://rclone.org/).
