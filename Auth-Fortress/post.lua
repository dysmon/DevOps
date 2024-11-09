wrk.method = "POST"
wrk.body   = '{"client_id": "test_client", "client_secret": "secret123", "scope": "read", "grant_type": "client_credentials"}'
wrk.headers["Content-Type"] = "application/json"
