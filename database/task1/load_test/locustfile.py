from locust import HttpUser, between, task

# Load UUIDs from a file
with open("uuids.txt") as f:
    uuid_list = f.read().splitlines()

class RecommendationUser(HttpUser):
    wait_time = between(1, 1)  # Simulate no wait time between requests
    counter = 0

    def on_start(self):
        # Assign a unique UUID from the list based on the user index
        self.user_id = uuid_list[RecommendationUser.counter % len(uuid_list)]
        RecommendationUser.counter += 1

    @task
    def trigger_recommendation(self):
        # print(f"Triggering recommendation for device ID: {self.device_id}")
        self.client.get(f"/recommendations?user_id={self.user_id}", name="Trigger Recommendation")
