API Endpoints
1. /token - Generate Token
Method: POST
Description: Generates a Bearer token for authenticated clients.
Params (JSON in request body):

    client_id (string, required): The client identifier.
    client_secret (string, required): The secret key for the client.
    scope (string, required): Space-separated list of requested scopes.
    grant_type (string, required): Must be "client_credentials".

Example Request:
POST /token
Content-Type: application/json

{
  "client_id": "test_client",
  "client_secret": "test_secret",
  "scope": "read write",
  "grant_type": "client_credentials"
}

Example Response:

{
  "access_token": "generated_access_token",
  "expires_in": 7200,
  "refresh_token": "",
  "scope": "read write",
  "security_level": "normal",
  "token_type": "Bearer"
}

```bash
curl -X POST http://medhelper.xyz/token \
-H "Content-Type: application/json" \
-d '{
  "client_id": "test_client",
  "client_secret": "secret123",
  "scope": "read",
  "grant_type": "client_credentials"
}'
```
```bash
{"access_token":"cd952367-9d5b-491a-8f43-a71058e5cb84","expires_in":7200,"refresh_token":"","scope":"read","security_level":"normal","token_type":"Bearer"}
```

2. /check - Check Token Validity

Method: GET
Description: Validates an existing token and returns the associated scopes if valid.
Headers:

    Authorization (string, required): Bearer token, e.g., Authorization: Bearer <token>

Example Request:

GET /check
Authorization: Bearer generated_access_token

Example Response:

{
  "client_id": "test_client",
  "scope": ["read", "write"]
}


Check Token:
```bash
curl -X GET http://medhelper.xyz/check \
-H "Authorization: Bearer cd952367-9d5b-491a-8f43-a71058e5cb84"
```
```bash
{"client_id":"test_client","scope":["read"]}
```


## Technology Stack

| Technology       | Purpose                                       |
|------------------|-----------------------------------------------|
| C++ with Boost   | Core language for backend service             |
| PostgreSQL       | Database for storing client and token data    |
| pqxx             | C++ library for interacting with PostgreSQL   |
| HashiCorp Vault  | Secure management of secrets and credentials  |
| Nginx            | Reverse proxy for HTTP requests               |
| Flyway           | Database migrations                           |
| Docker           | Containerization for consistent deployment    |
| Docker Compose   | Multi-container orchestration                 |
| Systemd          | Service management on Linux                   |
| GitLab CI/CD     | Automated build, test, and deploy pipelines   |
| Locust           | Load testing for performance validation       |
| Shell Scripting  | Dependency initialization (`wait-for-it.sh`)  |
