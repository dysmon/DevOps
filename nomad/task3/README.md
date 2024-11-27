
# Scaling FastAPI Service with Minimal Downtime

This project demonstrates scaling a FastAPI service to multiple instances while ensuring minimal downtime using two deployment strategies: **Blue-Green Deployment** and **Rolling Updates**. Both methods include health checks and configurations to maintain service availability during updates.

---

## Table of Contents
- [Overview](#overview)
- [Deployment Strategies](#deployment-strategies)
  - [Blue-Green Deployment](#blue-green-deployment)
  - [Rolling Updates](#rolling-updates)
- [Nomad Configuration](#nomad-configuration)
- [Usage](#usage)
- [Conclusion](#conclusion)

---

## Overview

The goal is to deploy the FastAPI service in a way that ensures:
- Minimal downtime during updates.
- Health checks to verify service stability.

Two deployment strategies are implemented:
1. **Blue-Green Deployment**: Deploys a new version in parallel with the existing one, switches traffic after the new version is validated.
2. **Rolling Updates**: Updates instances one at a time while keeping the majority running.

---

## Deployment Strategies

### Blue-Green Deployment

In this approach, a new set of instances is deployed while the old ones remain active. Traffic is switched to the new instances only if they pass health checks.

#### Nomad Job Configuration

```hcl
job "fastapi-app" {
  datacenters = ["kbtu"]
  group "fastapi-group" {
    count = 3

    network {
      port "http" {}
    }

    update {
      max_parallel     = 3
      canary           = 3
      min_healthy_time = "10s"
      healthy_deadline = "1m"
      auto_revert      = true
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
      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
```

---

### Rolling Updates

In this approach, instances are updated one at a time, ensuring the majority of instances remain active.

#### Nomad Job Configuration

```hcl
job "fastapi-app" {
  datacenters = ["kbtu"]
  group "fastapi-group" {
    count = 3

    network {
      port "http" {}
    }

    update {
      max_parallel     = 1
      min_healthy_time = "10s"
      healthy_deadline = "1m"
      auto_revert = true
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
      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
```

---

## Nomad Configuration

Ensure that Nomad is configured properly to support the deployment strategies:

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

## Usage

1. **Start Nomad Agent**:
   ```bash
   nomad agent -config=nomad.hcl
   ```

2. **Deploy Blue-Green Strategy**:
   ```bash
   nomad job run blue_green.nomad
   ```

3. **Deploy Rolling Updates Strategy**:
   ```bash
   nomad job run rolling_updates.nomad
   ```

4. **Monitor Deployment**:
   Use the Nomad UI or CLI to monitor the status of deployments.

---
