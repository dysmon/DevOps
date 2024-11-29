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

