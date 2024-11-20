
# MinIO Distributed Cluster Setup

## Overview
This script sets up a **distributed MinIO cluster** with 3 nodes using **Docker containers**. Each MinIO node runs as a separate **systemd service** to ensure automatic restarts and resilience. The nodes are connected through a custom Docker network, and the cluster is set up with erasure coding for data replication and availability.

## Prerequisites
- **Docker** installed and running.

## Script Overview
- **3 MinIO nodes**: Each running in a Docker container as a systemd service.
- **Automatic service restart**: Using `systemd` to ensure MinIO nodes restart on failure.
- **Data replication**: MinIO distributes and replicates data across all 3 nodes.
- **Failure simulation**: Ensures that data remains available even if one or more nodes fail.

## Instructions

### 1. Clone or Copy the Script
Download or copy the `minio_setup` script to your desired directory.

### 2. Modify Configuration (Optional)
Edit the script to configure:
- MinIO root user and password.
- MinIO node names, ports, and data directory paths.
- Docker image version if necessary.

```bash
MINIO_ROOT_USER="minioadmin"
MINIO_ROOT_PASSWORD="minioadminpassword"
MINIO_NODES=(
  "minio1:9001:9011:data1"
  "minio2:9002:9012:data2"
  "minio3:9003:9013:data3"
)
```

### 3. Run the Script
Run the script to set up the distributed MinIO cluster:

```bash
bash minio_setup
```

This will:
- Pull the MinIO Docker image.
- Create a Docker network (`minio-cluster-net`).
- Set up and start MinIO nodes as systemd services.

### 4. Verify the Cluster
After the script runs successfully, you can verify the MinIO nodes and the distributed setup by accessing the MinIO console at:
- **MinIO1**: `http://localhost:9011`
- **MinIO2**: `http://localhost:9012`
- **MinIO3**: `http://localhost:9013`

### 5. Simulate Node Failures
To test data resilience, simulate a node failure by stopping one of the MinIO services and verifying the availability of data:
```bash
systemctl stop minio1.service
```

MinIO should still be functional with data accessible through the remaining nodes. After a failure, restart the stopped service:
```bash
systemctl start minio1.service
```

## Data Replication & Availability
MinIO replicates data across all nodes in the cluster. With 3 nodes, MinIO ensures that data is always available even if one or two nodes fail, as long as the majority of nodes are operational.

## Troubleshooting
- Ensure Docker is running and the correct ports are available.
- Check MinIO logs for any errors or issues:
  ```bash
  journalctl -u minio1.service
  journalctl -u minio2.service
  journalctl -u minio3.service
  ```
