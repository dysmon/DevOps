from locust import HttpUser, task, constant

class MyUser(HttpUser):
    wait_time = constant(0.1)  # Минимальная задержка между запросами для максимальной нагрузки

    @task
    def post_token_request(self):
        headers = {"Content-Type": "application/json"}
        data = {
            "client_id": "test_client",
            "client_secret": "secret123",
            "scope": "read",
            "grant_type": "client_credentials"
        }
        self.client.post("/token", headers=headers, json=data)
