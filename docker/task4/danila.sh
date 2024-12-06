#! /bin/bash

echo "Starting GitLab Runner Service at $(date)"
GIRLAB_URL="https://gitlab.com"
GITLAB_ACCESS_TOKEN="glpat-jj2bWyH6EVc2Vo-YqrUi"
PROJECT_GROUP="98283240"
MIN_RUNNERS=1
MAX_RUNNERS=5
RUNNER_IMAGE="bekonchick/gitlab-runner-docker4:latest"

get_current_projects_ids() {
  projects=($(curl -g --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "$GIRLAB_URL/api/v4/groups/$PROJECT_GROUP/projects/" | jq '.[].id'))
  echo "Projects: " "${projects[@]}"
  export projects
}

get_current_active_runners() {
  current_runners=$(docker container ls --filter=ancestor=$RUNNER_IMAGE --format "{{.ID}}" | wc -l)
  export current_runners
}

get_pending_jobs() {
  pending_jobs_all=0
  for project_id in "${projects[@]}"; do
    pending_jobs_num=$(curl -g --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "$GIRLAB_URL/api/v4/projects/$project_id/jobs?scope=pending" | jq length);
    echo "Pending Jobs: $pending_jobs_num"
    pending_jobs_all=$(($pending_jobs_all + $pending_jobs_num))
  done
}

get_running_jobs() {
  running_jobs_all=0
  for project_id in "${projects[@]}"; do
    running_jobs_info=$(curl -g --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "$GIRLAB_URL/api/v4/projects/$project_id/jobs?scope=running")
    running_jobs_num=$(echo "$running_jobs_info" | jq length);
    running_jobs_runners_ids=$(echo "$running_jobs_info" | jq '.[].runner.id' | sort | uniq)
    echo "Running Jobs: $running_jobs_num"
    running_jobs_all=$(($running_jobs_all + $running_jobs_num))
  done
}

run_new_runner() {
  response=$(curl -X"POST" --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" --data "runner_type=group_type&group_id=$PROJECT_GROUP" "$GIRLAB_URL/api/v4/user/runners")
  token=$(echo "$response" | jq -r .token)
  runner_id=$(echo "$response" | jq -r .id)

  docker run --rm -d --name gitlab-runner-$runner_id $RUNNER_IMAGE
}

stop_runner() {
  # stop runner that gitlab-runner-{id} not in running_jobs_runners_ids
  for container_id in $(docker container ls --filter=ancestor=$RUNNER_IMAGE --format "{{.Names}}"); do
    container_runner_id=$(echo $container_id | cut -d'-' -f3)
    if [[ ! " ${running_jobs_runners_ids[*]} " =~ "$container_runner_id" ]]; then
      docker container stop $container_id
      curl --request DELETE --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" "$GIRLAB_URL/api/v4/runners/$container_runner_id"
    fi
  done
}

get_current_projects_ids
get_current_active_runners
get_pending_jobs
get_running_jobs
echo "Current Runners: $current_runners"
echo "Pending Jobs: $pending_jobs_all"
echo "Running Jobs: $running_jobs_all"

# Init runners
if [ $current_runners -eq 0 ]; then
  for i in $(seq 1 $(($MIN_RUNNERS))); do
    run_new_runner
  done
fi

if [ $pending_jobs_all -gt 0 ]; then
  for i in $(seq 1 $pending_jobs_all); do
    if [ $current_runners -lt $MAX_RUNNERS ]; then
      run_new_runner
      echo "New runner started"
      current_runners=$(($current_runners+1))
    fi
  done
elif [ $(($running_jobs_all - $current_runners)) -lt 0 ]; then
  for i in $(seq 1 $(($current_runners - $running_jobs_all))); do
    if [ $current_runners -gt $MIN_RUNNERS ]; then
      stop_runner
      echo "Runner stopped"
      current_runners=$(($current_runners-1))
    fi
  done
fi

echo "GitLab Runner Service finished at $(date)"