#!/bin/bash

URL=$1

if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <token>"
	exit 1
fi

RUNNER_TOKEN=$(curl --request POST --header "PRIVATE-TOKEN: $ACCESS_TOKEN" --data "runner_type=group_type" --data "group_id=93957444" "https://gitlab.com/api/v4/user/runners" | jq -r '.token')

register_runner() {

	sudo gitlab-runner register \
	  --non-interactive \
	  --url "$URL" \
	  --token "$RUNNER_TOKEN" \	
	  --executor "shell" \
	  --description "gitlab-runner"  
}

register_runner


