#!/bin/bash

set -euo pipefail


GITLAB_URL="https://gitlab.com"                    
PROJECT_GROUP="98283240"                        
GITLAB_ACCESS_TOKEN="glpat-jj2bWyH6EVc2Vo-YqrUi"  
RUNNER_IMAGE="docker-runner5"   
MIN_RUNNERS=0
MAX_RUNNERS=5

LOG_FILE="/var/log/gitlab-runner-scaler.log"
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" | tee -a "$LOG_FILE"
}

#project IDs in the group
get_current_projects_ids() {
  log "Fetching current project IDs..."
  local response
  response=$(curl -s --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" \
    "$GITLAB_URL/api/v4/groups/$PROJECT_GROUP/projects/")

  projects=($(echo "$response" | jq '.[].id'))

  if [ ${#projects[@]} -eq 0 ]; then
    log "No projects found in group $PROJECT_GROUP."
    exit 1
  fi

  log "Projects: ${projects[@]}"
}

#current number of active runners
get_current_active_runners() {
  log "Fetching current active runners..."
  current_runners=$(docker container ls --filter "ancestor=$RUNNER_IMAGE" --format "{{.ID}}" | wc -l)
  log "Current active runners: $current_runners"
}

#number of pending jobs across all projects
get_pending_jobs() {
  pending_jobs_all=0
  log "Calculating pending jobs..."
  for project_id in "${projects[@]}"; do
    pending_jobs_num=$(curl -s --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" \
      "$GITLAB_URL/api/v4/projects/$project_id/jobs?scope=pending" | jq 'length')

    log "Project $project_id has $pending_jobs_num pending jobs."
    pending_jobs_all=$((pending_jobs_all + pending_jobs_num))
  done
  log "Total pending jobs: $pending_jobs_all"
}

#get number of running jobs and their runner IDs
get_running_jobs() {
  running_jobs_all=0
  running_jobs_runners_ids=()
  log "Calculating running jobs..."
  for project_id in "${projects[@]}"; do
    running_jobs_info=$(curl -s --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" \
      "$GITLAB_URL/api/v4/projects/$project_id/jobs?scope=running")

    running_jobs_num=$(echo "$running_jobs_info" | jq 'length')
    runners_ids=$(echo "$running_jobs_info" | jq '.[].runner.id' | sort -u)

    log "Project $project_id has $running_jobs_num running jobs."
    running_jobs_all=$((running_jobs_all + running_jobs_num))

    if [ "$runners_ids" != "null" ] && [ "$runners_ids" != "" ]; then
      for id in $runners_ids; do
        running_jobs_runners_ids+=("$id")
      done
    fi
  done
  log "Total running jobs: $running_jobs_all"
}

#register a new runner
run_new_runner() {
  response=$(curl -X"POST" --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" --data "runner_type=group_type&group_id=$PROJECT_GROUP" "$GITLAB_URL/api/v4/user/runners")
  token=$(echo "$response" | jq -r .token)
  runner_id=$(echo "$response" | jq -r .id)

  docker run --rm -d --name gitlab-runner-$runner_id --privileged $RUNNER_IMAGE

  response=$(curl -s --request DELETE --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" \
    "$GITLAB_URL/api/v4/runners/$runner_id")

}

#stop
stop_runner() {
  for container_id in $(docker container ls --filter=ancestor=$RUNNER_IMAGE --format "{{.Names}}"); do
    container_runner_id=$(echo $container_id | cut -d'-' -f3)
    if [[ ! " ${running_jobs_runners_ids[*]} " =~ "$container_runner_id" ]]; then
      
      # docker exec -it $container_id sh -c "gitlab-runner unregister --token \$(awk -F'=' '/token =/ { gsub(/\"/,\"\",\$2); print \$2 }' /etc/gitlab-runner/config.toml)"
      docker exec -it $container_id sh -c "curl -s --request DELETE \
        --header 'PRIVATE-TOKEN: glpat-jj2bWyH6EVc2Vo-YqrUi' \
        \"https://gitlab.com/api/v4/runners/\$(awk -F'=' '/id =/ { gsub(/[^0-9]/,\"\",\$2); print \$2 }' /etc/gitlab-runner/config.toml)\""
      docker container stop $container_id
    fi
  done
}


############################################

manage_scaling() {
  log "Managing scaling..."

  if [ "$current_runners" -lt "$MIN_RUNNERS" ]; then
    runners_to_add=$((MIN_RUNNERS - current_runners))
    log "Adding $runners_to_add runner(s) to reach minimum of $MIN_RUNNERS."
    for _ in $(seq 1 "$runners_to_add"); do
      if [ "$current_runners" -lt "$MAX_RUNNERS" ]; then
        run_new_runner
        current_runners=$((current_runners + 1))
      else
        log "Maximum number of runners ($MAX_RUNNERS) reached."
        break
      fi
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
}


##########################################################


log "GitLab Runner Scaler Service started at $(date)"

get_current_projects_ids
get_current_active_runners
get_pending_jobs
get_running_jobs

log "Current Runners: $current_runners"
log "Pending Jobs: $pending_jobs_all"
log "Running Jobs: $running_jobs_all"

manage_scaling

log "GitLab Runner Scaler Service finished at $(date)"