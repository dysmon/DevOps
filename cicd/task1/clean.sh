#!/bin/bash

echo "Stopping GitLab Runner service..."
sudo gitlab-runner stop

echo "Unregistering GitLab Runner..."
sudo gitlab-runner unregister -all-runners

echo "Removing GitLab Runner..."
sudo apt-get remove --purge gitlab-runner -y

echo "Cleaning up configuration files..."
sudo rm -rf /etc/gitlab-runner

echo "Removing GitLab Runner user..."
sudo userdel gitlab-runner
