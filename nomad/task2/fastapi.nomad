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

