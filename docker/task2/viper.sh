#!/bin/bash

container_ids=($(docker ps -q))
current_date_epoch=$(date +%s)

update_journal() {
	for container in "${container_ids[@]}"; do
		image_id=$(docker inspect -f '{{ .Image }}' "$container")
		if grep -q $image_id viper_journal; then
			sed -i "s|^IMAGE_ID: $image_id.*|IMAGE_ID: $image_id LAST_USAGE: $current_date_epoch|" viper_journal
		else
			echo "IMAGE_ID: $image_id LAST_USAGE: $current_date_epoch" >> viper_journal
		fi
	done
}

mail=raibekovdias@gmail.com

delete_unused() {
	while read -r line; do
		image_id=$(echo "$line" | awk '{print $2}')
		last_used=$(echo "$line" | awk '{print $4}')
		age_days=$(( (current_date_epoch - last_used) / 86400 ))
		if [ "$age_days" -ge 30 ]; then
			log_message="LOG[INFO] Deleted image $image_id, Current date $(date)"
			docker rmi -f "$image_id" > /dev/null
			
			# Log message and send email
			echo $log_message && echo "$log_message" | mail -s "new_log" $mail
			
			sed -i "/^IMAGE_ID: $image_id.*/d" viper_journal
		fi
	done < viper_journal
}

## MAIN
update_journal
delete_unused
