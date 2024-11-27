
# Manual Blue-Green Deployment with Nginx

This guide demonstrates how to simulate a blue-green deployment for a service using Nginx as a reverse proxy, without using HashiCorp Nomad. The deployment switches between two versions of an application (blue and green) by updating the Nginx configuration to proxy traffic to the desired version.

## Prerequisites

1. **Nginx** should be installed and running on your system.
2. **Docker** should be installed to run the application containers.
3. Ensure that your system can access `localhost` on ports `8081` and `8082` (for blue and green app versions, respectively).

## Step 1: Configure Nginx for Blue-Green Deployment

Create the Nginx configuration file `/etc/nginx/conf.d/blue-green.conf` with the following content:

```nginx
upstream app_blue {
    server localhost:8081;
}

upstream app_green {
    server localhost:8082;
}

server {
    listen 8080;

    location / {
        proxy_pass http://app_green;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

This configuration sets up two upstream blocks: `app_blue` and `app_green`. Initially, Nginx will route all incoming traffic on port `8080` to the green version of the application (`localhost:8082`).

## Step 2: Deployment Switch Script

You can manually switch between the blue and green environments using a simple shell script. The script updates the Nginx configuration and reloads Nginx.

### `deployment_switch.sh` script:

```bash
#!/bin/bash

if [ "$1" == "blue" ]; then
  sed -i 's|proxy_pass http://app_green;|proxy_pass http://app_blue;|' /etc/nginx/conf.d/blue-green.conf
elif [ "$1" == "green" ]; then
  sed -i 's|proxy_pass http://app_blue;|proxy_pass http://app_green;|' /etc/nginx/conf.d/blue-green.conf
else
  echo "Usage: $0 <blue|green>"
  exit 1
fi

sudo nginx -s reload
echo "Switched to $1 environment"
```

### Usage:

- To switch to the **blue** environment (app running on port `8081`):

  ```bash
  ./deployment_switch.sh blue
  ```

- To switch to the **green** environment (app running on port `8082`):

  ```bash
  ./deployment_switch.sh green
  ```

## Step 3: Running the Application Containers

### 1. **Launch Blue Application**:

Run the blue version of the application using the following `docker` command:

```bash
docker run --network host -d --name app_blue -e PORT=8081 diasraibek/nomad_fastapi:1.1
```

This command starts the blue application container and listens on port `8081`.

### 2. **Launch Green Application** (for updates or new version):

Run the green version of the application (for example, a new version) using:

```bash
docker run --network host -d --name app_green -e PORT=8082 diasraibek/nomad_fastapi:latest
```

This command starts the green application container and listens on port `8082`.

## Step 4: Switch Between Blue and Green Environments

To switch the traffic from the blue app to the green app, or vice versa, use the `deployment_switch.sh` script to update the Nginx configuration and reload it.

- Switch to the blue app:

  ```bash
  ./deployment_switch.sh blue
  ```

- Switch to the green app:

  ```bash
  ./deployment_switch.sh green
  ```

The Nginx reverse proxy will route the traffic to the selected application.
