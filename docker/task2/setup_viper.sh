#!/bin/bash

# Variables
WORK_DIR="/home/dias/DevOps/docker/task2"
SERVICE_NAME="viper"
SCRIPT_PATH="./viper.sh"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"
TIMER_FILE="/etc/systemd/system/$SERVICE_NAME.timer"

creating_service() {
	echo "Creating $SERVICE_FILE..."
	cat <<EOL | sudo tee $SERVICE_FILE > /dev/null
[Unit]
Description=Viper Script Service
Wants=$SERVICE_NAME.timer

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

creating_timer() {
	echo "Creating $TIMER_FILE..."
	cat <<EOL | sudo tee $TIMER_FILE > /dev/null
[Unit]
Description=Run Viper Script Every Minute

[Timer]
OnBootSec=1min
OnUnitActiveSec=1min
Unit=$SERVICE_NAME.service

[Install]
WantedBy=timers.target
EOL
}

start() {
	sudo systemctl daemon-reload
	sudo systemctl start $SERVICE_NAME.timer
}
## MAIN
creating_service
creating_timer
start
