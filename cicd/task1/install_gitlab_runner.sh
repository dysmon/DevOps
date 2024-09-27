#!/bin/bash

install_runner() {
	if ! grep -q "packages.gitlab.com" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
		curl -sL "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
	else
		echo "GitLab Runner repo already exists."
	fi
	
	if ! dpkg -l | grep -q gitlab-runner; then
		sudo apt install -y gitlab-runner
		echo "Gitlab Runner installed."
	else
		echo "Gitlab Runner is already installed."
	fi
}

enable_autostart() {
	sudo systemctl start gitlab-runner
	sudo systemctl enable gitlab-runner
	echo "GitLab Runner enabled to start on boot"
}

install_runner
enable_autostart
