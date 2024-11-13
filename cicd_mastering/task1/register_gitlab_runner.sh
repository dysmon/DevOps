#!/bin/bash

RUNNER_TOKEN=$(curl --request POST --header "PRIVATE-TOKEN: $ACCESS_TOKEN" --data "runner_type=group_type" --data "group_id=93957444" "https://gitlab.com/api/v4/user/runners" | jq -r '.token')

register_runner() {

	sudo gitlab-runner register \
	  --non-interactive \
	  --url "https://gitlab.com/" \
	  --token "$RUNNER_TOKEN" \	
	  --executor "shell" \
	  --description "gitlab-runner"
	  # --tag-list "shared" after updates it's impossible to do without premium gitlab
}

register_runner


