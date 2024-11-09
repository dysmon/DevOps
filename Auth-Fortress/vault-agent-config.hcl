auto_auth {
  method {
    type = "approle"
    config = {
      role_id_file_path = "/etc/vault/role_id"
      secret_id_file_path = "/etc/vault/secret_id"
      remove_secret_id_file_after_reading = false
    }
  }

  sink {
    type = "file"
    config = {
      path = "/etc/vault/token"
    }
  }
}

template {
  source      = "/etc/vault/templates/config.tpl"
  destination = "/etc/vault/secrets/config.json"
}

# Опционально: кэширование и обновление токенов
cache {
  use_auto_auth_token = true
}
