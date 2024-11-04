
# Aiohttp Simple Server in Docker

This project provides a Docker image for running the Aiohttp Simple Server application from the repository [aiohttp-simple-server](https://gitlab.com/lecture-tasks/intro-devops/aiohttp-simple-server/). The Dockerfile follows best practices to create an optimized, minimal Docker image with multi-stage builds to reduce the final image size, efficient caching, and proper use of layers.

## Functional Requirements

- **Minimal/Optimal base image**: Uses `python:3.9-slim` in the build stage and `python:3.9-alpine` for the final image.
- **No use of the latest tag**: Specific Python versions are used (`python:3.9-slim` and `python:3.9-alpine`).
- **Multi-stage build**: Two stages are used to separate the build process from the final image to minimize the size.
- **Efficient caching and layer management**: Dependencies are installed efficiently in one layer, and unnecessary files like `apt` cache are removed to optimize image size.
- **No unnecessary installations**: Only Python dependencies (`aiohttp`) are installed on final image.
- **Reduced Docker context**: Only the required source code is copied to the final image.
- **CMD / ENTRYPOINT correctly chosen**: Uses `ENTRYPOINT` to run the Aiohttp server on startup.

## Dockerfile Breakdown

### Stage 1: Build Stage
- **Base Image**: `python:3.9-slim`
- **Purpose**: Clones the source code and prepares the application.
- **Optimizations**:
  - Uses `--no-install-recommends` to avoid installing unnecessary packages.
  - Cleans up unnecessary files from the system cache to reduce image size.

### Stage 2: Final Image
- **Base Image**: `python:3.9-alpine`
- **Purpose**: Installs only necessary dependencies and runs the application.
- **Optimizations**:
  - Installs the `aiohttp` dependency directly into the final image.
  - Copies the application files from the build stage to minimize context and ensure that no development tools or unnecessary files are included.
  - Exposes port 8080 for the Aiohttp server.

## How to Build and Run the Docker Image

1. **Build the Docker Image**:

   Run the following command to build the image using the provided Dockerfile:

   ```bash
   docker build -t aiohttp-simple-server:1 .
   ```

2. **Run the Docker Container**:

   After building the image, you can run the container with the following command:

   ```bash
   docker run -p 8080:8080 aiohttp-simple-server:1
   ```

   This will map port 8080 on the host to port 8080 in the container, allowing you to access the Aiohttp server at `http://localhost:8080`.

## Dockerfile Overview

```dockerfile
# Stage 1: Build stage
FROM python:3.9-slim AS builder

WORKDIR /app

# Install git to clone the source code
RUN apt-get update && apt-get install -y --no-install-recommends git

# Clone the source code from the GitLab repository
RUN git clone https://gitlab.com/lecture-tasks/intro-devops/aiohttp-simple-server.git /app

# Stage 2: Final image
FROM python:3.9-alpine

WORKDIR /app

# Install the aiohttp dependency
RUN pip install --no-cache-dir aiohttp

# Copy the necessary files from the build stage
COPY --from=builder /app /app

# Expose the port for the Aiohttp server
EXPOSE 8080

# Start the Aiohttp server
ENTRYPOINT ["python", "app/main.py"]
```
