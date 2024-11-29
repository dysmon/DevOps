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
