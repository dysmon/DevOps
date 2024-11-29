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
