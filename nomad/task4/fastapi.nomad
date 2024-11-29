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

