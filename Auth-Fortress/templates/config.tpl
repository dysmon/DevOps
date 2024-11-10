{
  "DB_CONNECTION": "{{ with secret "secret/data/db_connection" }}{{ .Data.data.connection_string }}{{ end }}"
}