
# FastAPI Deployment with Dynamic Port Allocation Using Nomad

This project demonstrates how to configure and deploy a FastAPI application using HashiCorp Nomad with dynamic port allocation. The solution includes a `Dockerfile` for containerization and a Nomad job definition to orchestrate the deployment.

---

## Table of Contents
- [Project Overview](#project-overview)
- [Setup and Configuration](#setup-and-configuration)
- [Usage](#usage)
- [Nomad Configuration](#nomad-configuration)
- [Dockerfile](#dockerfile)
- [Nomad Job File](#nomad-job-file)

---

## Project Overview

The FastAPI application consists of two endpoints:
1. **Root Endpoint (`/`)**: Returns a welcome message and the dynamically assigned port.
2. **Health Check Endpoint (`/health`)**: Returns the status of the API.

### Application Code

[Source Code Repository](https://gitlab.com/Dysmon/simple_api.git)
---

## Setup and Configuration

1. **Install Required Tools**:
   - [Docker](https://docs.docker.com/get-docker/)
   - [Nomad](https://developer.hashicorp.com/nomad/docs)

2. **Build Docker Image**:
   Create a `Dockerfile` with the required dependencies and build the image.

3. **Configure Nomad Agent**:
   Set up `nomad.hcl` with client and server configurations.

4. **Run Nomad Job**:
   Use the provided Nomad job file to deploy the FastAPI application.

---

## Usage

### Build and Run the Docker Image

```bash
docker build -t diasraibek/nomad_fastapi:1.1 .
docker run -p 8000:8000 diasraibek/nomad_fastapi:1.1
```

### Run Nomad Agent

```bash
nomad agent -config=nomad.hcl
```

### Deploy the Job

```bash
nomad job run fastapi.nomad
```

---

## Nomad Configuration

### `nomad.hcl`

```hcl
data_dir = "/home/dias/Desktop"
bind_addr = "0.0.0.0"
log_level = "INFO"
datacenter = "kbtu"

server {
  enabled = true
  bootstrap_expect = 1
}

client {
  enabled = true
  servers = ["127.0.0.1:4646"]
}

plugin "docker" {
  config {
    allow_privileged = true
  }
}
```

---

## Dockerfile

```dockerfile
FROM python:3.9-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    && rm -rf /var/lib/apt/lists/*
RUN git clone https://gitlab.com/Dysmon/simple_api.git /app

FROM python:3.9-alpine

WORKDIR /app

RUN pip install --no-cache-dir fastapi uvicorn
COPY --from=builder /app /app
ENTRYPOINT ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port $PORT"]
```

---

## Nomad Job File

### `fastapi.nomad`

```hcl
job "fastapi-app" {
  datacenters = ["kbtu"]
  group "fastapi-group" {
    count = 3

    network {
      port "http" {}
    }

    task "fastapi" {
      driver = "docker"

      config {
        image = "diasraibek/nomad_fastapi:1.1"
        ports = ["http"]
      }
      env {
        PORT = "${NOMAD_PORT_http}"
      }
    }
  }
}
```

---
