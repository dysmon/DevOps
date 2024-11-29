
# Auto-Scaling Solution with Nomad

This project demonstrates how to automatically adjust the number of instances of a job in HashiCorp Nomad based on CPU and memory utilization. Additionally, it includes a solution for generating artificial load to trigger the auto-scaling policy.

## Overview

- **Objective**: Automatically scale the number of instances of the `fastapi` job in Nomad based on CPU or memory usage.
- **Solution**: We use Nomad's native scaling feature combined with artificial CPU and memory load generation to trigger the auto-scaling policy.

## Requirements

- **HashiCorp Nomad**: A tool for orchestrating containers, jobs, and services across multiple nodes.
- **Docker**: For running the `fastapi` application as a container.
- **Nomad-Apm Plugin**: Used to collect resource usage metrics for scaling policies.

## Configuration Files

### 1. `nomad.hcl`

This configuration file sets up the Nomad agent, enabling both server and client functionality. The client is configured to use an `autoscaler` node class.

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
  node_class = "autoscaler"
  servers = ["127.0.0.1:4646"]
}

plugin "docker" {
  config {
    allow_privileged = true
  }
}

telemetry {
  publish_allocation_metrics = true
  publish_node_metrics       = true
}
```

### 2. `autoscale.hcl`

This configuration file enables auto-scaling for the `fastapi` job based on CPU and memory usage. It uses the `nomad-apm` plugin to track resource metrics.

```hcl
enable_debug = true
log_level = "DEBUG"

nomad {
  address = "http://127.0.0.1:4646"
}

apm "nomad-apm" {
  driver = "nomad-apm"
}

http {
  bind_address = "0.0.0.0"
  bind_port    = 8084
}

strategy "target-value" {
  driver = "target-value"
}
```

### 3. `fastapi.nomad`

This job configuration file defines the `fastapi` application and includes the scaling policy. It scales the number of instances between 1 and 3 based on CPU and memory utilization, with the target value set to 70%.

```hcl
job "fastapi-app" {
  datacenters = ["kbtu"]
  group "fastapi-group" {
    count = 1

    network {
      port "http" {}
    }
    
    scaling {
      enabled = true
      min     = 1
      max     = 3
      
      policy {
        evaluation_interval = "15s"
        cooldown            = "30s"
        
        check "cpu" {
          source = "nomad-apm"
          query = "avg_cpu-allocated"
          strategy "target-value" {
                target = 70
          }
         }
         
         check "memory" {
           source = "nomad-apm"
           query = "avg_memory-allocated"
           strategy "target-value" {
                target = 70
           }
         }
       }
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

### 4. Generate Artificial CPU and Memory Load

To trigger the auto-scaling policy, we can simulate artificial CPU and memory load inside the container. The following commands can be executed inside the container to create the load:

```bash
# Install the stress-ng tool to simulate load
apk add stress-ng

# Generate CPU and memory load
stress-ng --vm 1 --vm-bytes 300M --timeout 30s
```

This command will create a memory load of 300MB and run for 30 seconds, simulating resource usage that will trigger the auto-scaling policy.

## Steps to Run the Solution

1. **Start Nomad**: Ensure Nomad is running and configured with the necessary `nomad.hcl` and `autoscale.hcl` files.

2. **Deploy the FastAPI Job**:
   Deploy the `fastapi.nomad` job using the Nomad CLI:

   ```bash
   nomad job run fastapi.nomad
   ```

3. **Monitor Scaling**: The job will automatically scale the number of instances based on the CPU and memory utilization as per the configuration in `fastapi.nomad`. Nomad will adjust the number of instances between 1 and 3 based on resource usage.

4. **Generate Load**: Inside the running container, execute the following to generate load and trigger the auto-scaling policy:

   ```bash
   apk add stress-ng
   stress-ng --vm 1 --vm-bytes 300M --timeout 30s
   ```

5. **Observe the Scaling**: Monitor the scaling activity in the Nomad UI or through the Nomad logs. The job will scale up or down based on the defined resource thresholds.

## References

- [Nomad Documentation](https://www.nomadproject.io/docs)
- [Stress-ng Documentation](https://man7.org/linux/man-pages/man1/stress-ng.1.html)
