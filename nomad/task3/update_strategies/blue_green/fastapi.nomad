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

