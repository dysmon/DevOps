
# PostgreSQL Deployment with Persistent Volumes and Backup using Nomad

## Overview

This solution demonstrates how to deploy PostgreSQL using Nomad, configure persistent volumes to retain data, and set up periodic backups to a local or remote location. Additionally, it includes steps to simulate node failure and restore the database from a backup.

---

## Prerequisites

- **Nomad** installed and running on your system.
- A directory created on the host system to store PostgreSQL data (e.g., `/home/dias/data/pgdata`).
- Docker installed and configured on the Nomad client node.

---

## Solution Components

### 1. **Nomad Configuration (`nomad.hcl`)**

The Nomad configuration sets up both server and client functionality, including the definition of a host volume for storing PostgreSQL data persistently.

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

  host_volume "pgdata" {
    path = "/home/dias/data/pgdata"
    read_only = false
  }
}

plugin "docker" {
  config {
    allow_privileged = true
  }
}
```

### 2. **PostgreSQL Deployment Job (`postgres.nomad`)**

This job file deploys a PostgreSQL container with the following:
- Persistent data storage using the `pgdata` host volume.
- Custom database credentials and configuration.
- Exposed port for database access.

```hcl
job "postgres" {
  datacenters = ["kbtu"]

  group "postgres-group" {
    count = 1

    network {
      port "db" {
        static = 5432
      }
    }	

    volume "pgdata" {
      type      = "host"
      source    = "pgdata"
      read_only = false
    }

    task "postgres-task" {
      driver = "docker"
      
      volume_mount {
        volume = "pgdata"
        destination = "/var/lib/postgresql/data"
        read_only = false
      }

      config {
        image = "postgres:latest"
        ports = ["db"]
      }

      env {
        POSTGRES_USER     = "admin"
        POSTGRES_PASSWORD = "password"
        POSTGRES_DB       = "exampledb"
      }

      resources {
        cpu    = 500
        memory = 512
      }
    }
  }
}
```

---

## Steps to Deploy

### 1. **Start Nomad**
Run the Nomad agent:
```bash
nomad agent -config=nomad.hcl
```

### 2. **Run the PostgreSQL Job**
Submit the job to Nomad:
```bash
nomad job run postgres.nomad
```

### 3. **Verify Deployment**
Check the status of the job:
```bash
nomad job status postgres
```

Access the PostgreSQL container to verify the data directory:
```bash
docker exec -it <container_id> bash
ls /var/lib/postgresql/data
```

## Simulate Node Failure

1. **Stop the Nomad Client Node:**
   ```bash
   systemctl stop nomad
   ```

2. **Verify Failure:**
   Check the job status. It should show "lost" allocations:
   ```bash
   nomad job status postgres
   ```

---

