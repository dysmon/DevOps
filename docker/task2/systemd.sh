#!/bin/bash

WORK_DIR="/home/bekarys/Desktop/devops/docker/task2"

SERVICE_NAME="viper"
TIMER_NAME="viper.timer"

SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"
TIMER_FILE="/etc/systemd/system/$TIMER_NAME"

SCRIPT_PATH="$WORK_DIR/viper.sh"

create_service() {
    echo "Creating $SERVICE_FILE..."

    sudo tee "$SERVICE_FILE" > /dev/null <<EOL
[Unit]
Description=Viper Docker Cleanup Service
After=network.target

[Service]
Type=oneshot
ExecStart=/bin/bash $SCRIPT_PATH
WorkingDirectory=$WORK_DIR
StandardOutput=append:$WORK_DIR/viper_logs
StandardError=append:$WORK_DIR/viper_logs

[Install]
WantedBy=multi-user.target
EOL
}

create_timer() {
    echo "Creating $TIMER_FILE..."

    sudo tee "$TIMER_FILE" > /dev/null <<EOL
[Unit]
Description=Run Viper Docker Cleanup Script Every Day

[Timer]
OnBootSec=10min
OnUnitActiveSec=1d
Unit=$SERVICE_NAME.service

[Install]
WantedBy=timers.target
EOL
}

start_services() {
    echo "Reloading systemd daemon..."
    sudo systemctl daemon-reload

    echo "Enabling and starting the timer..."
    sudo systemctl enable --now "$TIMER_NAME"
}

create_service
create_timer
start_services

echo "Service and Timer for Viper Docker Cleanup have been set up successfully."