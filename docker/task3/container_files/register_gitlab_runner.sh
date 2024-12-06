#!/bin/bash

# Start Docker daemon
echo "Starting Docker daemon..."
dockerd-entrypoint.sh &

# Wait for Docker daemon to be ready
echo "Waiting for Docker daemon to start..."
while (! docker info > /dev/null 2>&1 ); do
  sleep 1
done
echo "Docker daemon started."

link=$GITLAB_SOURCE
access_token=$GITLAB_ACCESS_TOKEN
project_group=$PROJECT_GROUP


# Register GitLab Runner
echo "Registering GitLab Runner..."
echo "Link: $link"
echo "Access Token: $access_token"
echo "Project Group: $project_group"

if [ -n "$access_token" ]; then
  if [ -n "$project_group" ]; then
    response=$(curl -X POST --header "PRIVATE-TOKEN: $access_token" \
      --data "runner_type=group_type&group_id=$project_group" \
      "$link/api/v4/user/runners")
    
    echo "Response: $response"
    token=$(echo "$response" | jq -r .token)
    echo "Token: $token"

    sudo gitlab-runner register --non-interactive \
      --url "$link" \
      --registration-token "$token" \
      --executor "docker" \
      --docker-image "ruby:3.3" \
      --name "docker-runner" \
      --docker-volumes "/var/run/docker.sock:/var/run/docker.sock" \
      --docker-privileged
  else
    echo "Project group was not provided."
    exit 1
  fi
else 
  echo "Access token was not provided."
  exit 1
fi

# Run GitLab Runner
echo "Starting GitLab Runner..."
gitlab-runner run
