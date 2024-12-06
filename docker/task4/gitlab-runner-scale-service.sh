#!/bin/bash

set -e

WORK_DIR="/home/bekarys/Desktop/devops/docker/task4"

SERVICE_NAME="gitlab-runner-scale"
TIMER_NAME="gitlab-runner-scale.timer"

SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"
TIMER_FILE="/etc/systemd/system/${TIMER_NAME}"

SCRIPT_PATH="${WORK_DIR}/gitlub-runner-scale.sh"

LOG_FILE="${WORK_DIR}/gitlab-runner-scaler.log"
ERROR_LOG_FILE="${WORK_DIR}/gitlab-runner-scaler-error.log"







create_service() {
    echo "Creating $SERVICE_FILE..."

    sudo tee "$SERVICE_FILE" > /dev/null <<EOL
[Unit]
Description=GitLab Runner Auto-Scaler Service
After=network.target docker.service
Requires=docker.service

[Service]
Type=oneshot
ExecStart=/bin/bash ${SCRIPT_PATH}
WorkingDirectory=${WORK_DIR}
StandardOutput=append:${LOG_FILE}
StandardError=append:${ERROR_LOG_FILE}
EnvironmentFile=/etc/gitlab-runner-scaler.env

[Install]
WantedBy=multi-user.target
EOL

    echo "Service file created at $SERVICE_FILE."
}

create_timer() {
    echo "Creating $TIMER_FILE..."

    sudo tee "$TIMER_FILE" > /dev/null <<EOL
[Unit]
Description=Run GitLab Runner Scaler Every 5 Minutes

[Timer]
OnBootSec=1min
OnUnitActiveSec=5min
Unit=${SERVICE_NAME}.service

[Install]
WantedBy=timers.target
EOL

    echo "Timer file created at $TIMER_FILE."
}





create_environment_file() {
    ENV_FILE="/etc/gitlab-runner-scaler.env"
    echo "Creating environment file at $ENV_FILE..."

    sudo tee "$ENV_FILE" > /dev/null <<EOL
# GitLab Runner Scaler Environment Variables
GITLAB_URL="https://gitlab.com"
PROJECT_GROUP="98283240"
GITLAB_ACCESS_TOKEN="glpat-jj2bWyH6EVc2Vo-YqrUi"
DEFAULT_RUNNER_IMAGE="docker-runner5"
MIN_RUNNERS=1
MAX_RUNNERS=5
EOL

    sudo chmod 600 "$ENV_FILE"
    sudo chown root:root "$ENV_FILE"

    echo "Environment file created and secured at $ENV_FILE."
}





start_services() {
    echo "Reloading systemd daemon..."
    sudo systemctl daemon-reload

    echo "Enabling and starting the timer..."
    sudo systemctl enable --now "$TIMER_NAME"

    echo "Timer $TIMER_NAME enabled and started."
}

create_log_files() {
    sudo touch "$LOG_FILE" "$ERROR_LOG_FILE"
    sudo chmod 644 "$LOG_FILE" "$ERROR_LOG_FILE"
    sudo chown root:root "$LOG_FILE" "$ERROR_LOG_FILE"

    echo "Log files created at $LOG_FILE and $ERROR_LOG_FILE."
}

echo "===== Setting Up GitLab Runner Scaler Service and Timer ====="

if [[ ! -f "$SCRIPT_PATH" ]]; then
    echo "Error: Scaling script not found at $SCRIPT_PATH."
    echo "Please ensure that gitlab-runner-scale.sh exists in $WORK_DIR."
    exit 1
fi

create_environment_file

create_log_files
create_service
create_timer
start_services

echo "===== GitLab Runner Scaler Service and Timer Setup Completed Successfully ====="