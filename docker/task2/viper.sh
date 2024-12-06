#!/bin/bash

WORK_DIR="/home/bekarys/Desktop/devops/docker/task2"

TELEGRAM_BOT_TOKEN="7392536801:AAF7X6YgEORtSAcsC8CMWS2C7gPXmVeKzmw"
TELEGRAM_CHAT_ID="672365571"

JOURNAL_FILE="$WORK_DIR/viper_journal"
LOG_FILE="$WORK_DIR/viper_logs"

MAX_UNUSED_DAYS=0


send_telegram_message() {
    local message="$1"
    local url="https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage"
    curl -s -X POST "$url" -d chat_id="$TELEGRAM_CHAT_ID" -d text="$message" -d parse_mode="Markdown" > /dev/null
}

update_journal() {
    local container_ids=($(docker ps -a -q))
    local current_date_epoch=$(date +%s)

    for container in "${container_ids[@]}"; do

        local image_id
        image_id=$(docker inspect -f '{{ .Image }}' "$container")
        
        if grep -q "IMAGE_ID: $image_id" "$JOURNAL_FILE"; then

            sed -i "s|^IMAGE_ID: $image_id.*|IMAGE_ID: $image_id LAST_USAGE: $current_date_epoch|" "$JOURNAL_FILE"

        else

            echo "IMAGE_ID: $image_id LAST_USAGE: $current_date_epoch" >> "$JOURNAL_FILE"
        fi

    done
}

delete_unused() {
    local current_date_epoch
    current_date_epoch=$(date +%s)
    local removed_images=()
    local removal_log=""

    if [ ! -f "$JOURNAL_FILE" ]; then
        touch "$JOURNAL_FILE"
    fi

    while read -r line; do
        image_id=$(echo "$line" | awk '{print $2}')
        last_used=$(echo "$line" | awk '{print $4}')

        age_days=$(( (current_date_epoch - last_used) / 86400 ))

        if [ "$age_days" -ge "$MAX_UNUSED_DAYS" ] && docker image inspect "$image_id" > /dev/null 2>&1; then
            if docker rmi -f "$image_id" > /dev/null 2>&1; then
                echo "hello, $image_id"  
                removal_log+="*$(date '+%Y-%m-%d %H:%M:%S')*: Deleted image \`$image_id\`  (Last used: $age_days days ago)\n"
                removed_images+=("$image_id")
                
            else
                removal_log+="*$(date '+%Y-%m-%d %H:%M:%S')*: Failed to delete image \`$image_id\` (Last used: $age_days days ago)\n"
            fi
        fi
    done < "$JOURNAL_FILE"

    for image in "${removed_images[@]}"; do
        sed -i "/^IMAGE_ID: $image.*/d" "$JOURNAL_FILE"
    done

    if [ -n "$removal_log" ]; then
        final_message="🧹 *Docker Cleanup Report*\n\n$removal_log"
        
        send_telegram_message "$final_message"
        
        echo -e "$final_message" >> "$LOG_FILE"
    fi
}


update_journal
delete_unused
