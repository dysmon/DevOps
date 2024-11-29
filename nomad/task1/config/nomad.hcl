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
