
# Containerized GitLab CI Runner

This project sets up a GitLab CI runner inside a Docker container. The runner is configured to execute pipeline jobs, such as building Docker images or running tests within containers.

## Features
- Install and configure a GitLab CI runner in a Docker container.
- Register the runner with a GitLab instance.
- Use Docker-in-Docker (DinD) to build Docker images or run tests within a container.

## Prerequisites
1. Docker installed on your host system.
2. A valid GitLab instance URL and access token for registering the GitLab runner.

## Dockerfile
The Dockerfile defines the setup for the containerized GitLab runner:

```dockerfile
# Use Ubuntu as the base image
FROM ubuntu:22.04

# Copy container files to the container
COPY ./container_files /container_files

# Set Docker driver environment variable
ENV DOCKER_DRIVER=vfs

# Update package list and install dependencies
RUN apt-get update && \
    apt-get install -y \
    curl \
    jq \
    docker.io \
    && apt-get clean && \
    chmod -R 755 /container_files
    
# Add the GitLab Runner repository and install
RUN curl -sL "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | bash && \
    apt-get install -y gitlab-runner

# Define a default command
ENTRYPOINT ["/bin/bash", "-c", "/container_files/register_gitlab_runner.sh && tail -f /dev/null"]
```

## Steps to Run
1. Build the Docker image for the runner:
    ```bash
    docker build -t image_name .
    ```
   
2. Run the Docker container with the necessary privileges and environment variables:
    ```bash
    docker run --privileged -e ACCESS_TOKEN=$ACCESS_TOKEN image_name
    ```

3. Tag your created gitlab runner as `docker`.
    Gitlab -> Groups -> Your_group -> Runners -> Right of your runner you can see edit button

## Example CI/CD Pipeline
To test the runner with Docker-in-Docker (DinD), use the following GitLab CI pipeline configuration:

```yaml
stages:
  - build

build:
  stage: build
  tags:
    - docker
  script:
    - docker build -t basic ./dind_test
    - docker run basic
```

This pipeline defines a `build` stage that builds a Docker image using DinD and runs the container.

## Notes
- Ensure that the runner is registered with the tag `docker` in your GitLab instance.
- The GitLab runner is set up with Docker-in-Docker to allow container builds within the pipeline jobs.
