#!/bin/bash

set -euo pipefail


GITLAB_URL="https://gitlab.com"                    
PROJECT_GROUP="98283240"                        
GITLAB_ACCESS_TOKEN="glpat-jj2bWyH6EVc2Vo-YqrUi"  
RUNNER_IMAGE="docker-runner5"   
MIN_RUNNERS=1
MAX_RUNNERS=5

# Log file location
LOG_FILE="/var/log/gitlab-runner-scaler.log"

# ------------------------------
# Helper Functions
# ------------------------------

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" | tee -a "$LOG_FILE"
}

# Function to get current project IDs in the group
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

# Function to get the current number of active runners
get_current_active_runners() {
  log "Fetching current active runners..."
  current_runners=$(docker container ls --filter "ancestor=$RUNNER_IMAGE" --format "{{.ID}}" | wc -l)
  log "Current active runners: $current_runners"
}

# Function to get the total number of pending jobs across all projects
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

# Function to get the total number of running jobs and their runner IDs
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

# Function to register a new runner
run_new_runner() {
  response=$(curl -X"POST" --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" --data "runner_type=group_type&group_id=$PROJECT_GROUP" "$GITLAB_URL/api/v4/user/runners")
  token=$(echo "$response" | jq -r .token)
  runner_id=$(echo "$response" | jq -r .id)

  docker run --rm -d --name gitlab-runner-$runner_id --privileged $RUNNER_IMAGE
}


# Function to stop and deregister a runner
stop_runner() {
  local container_name=$1
  local runner_id=$2

  log "Stopping and removing runner $runner_id (Container: $container_name)..."
  
  if docker container inspect "$container_name" > /dev/null 2>&1; then
    docker container stop "$container_name" || log "Container $container_name already stopped."
    docker container rm "$container_name" || log "Container $container_name already removed."
  else
    log "Container $container_name does not exist."
  fi

  # Deregister the runner from GitLab
  response=$(curl -s --request DELETE --header "PRIVATE-TOKEN: $GITLAB_ACCESS_TOKEN" \
    "$GITLAB_URL/api/v4/runners/$runner_id")

  if [ "$response" == "" ]; then
    log "Successfully deregistered runner $runner_id."
  else
    log "Failed to deregister runner $runner_id. Response: $response"
  fi
}

# Function to manage scaling
manage_scaling() {
  log "Managing scaling..."

  # Register minimum runners if current runners are less than MIN_RUNNERS
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

  # Scale up based on pending jobs
  if [ "$pending_jobs_all" -gt 0 ]; then
    log "Scaling up based on pending jobs..."
    for _ in $(seq 1 "$pending_jobs_all"); do
      if [ "$current_runners" -lt "$MAX_RUNNERS" ]; then
        run_new_runner
        log "New runner started."
        current_runners=$((current_runners + 1))
      else
        log "Maximum number of runners ($MAX_RUNNERS) reached."
        break
      fi
    done
  fi

  # Scale down if possible
  if [ "$running_jobs_all" -lt "$current_runners" ]; then
    runners_to_remove=$((current_runners - $running_jobs_all))
    log "Scaling down: removing $runners_to_remove runner(s)."
    for _ in $(seq 1 "$runners_to_remove"); do
      if [ "$current_runners" -gt "$MIN_RUNNERS" ]; then
        # Identify runners not handling any running jobs
        for container_id in $(docker container ls --filter "ancestor=$RUNNER_IMAGE" --format "{{.Names}}"); do
          container_runner_id=$(echo "$container_id" | cut -d'-' -f3)
          if [[ ! " ${running_jobs_runners_ids[@]} " =~ " $container_runner_id " ]]; then
            stop_runner "$container_id" "$container_runner_id"
            current_runners=$((current_runners - 1))
            break
          fi
        done
      else
        log "Minimum number of runners ($MIN_RUNNERS) reached."
        break
      fi
    done
  fi
}


# ------------------------------
# Main Execution Flow
# ------------------------------

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