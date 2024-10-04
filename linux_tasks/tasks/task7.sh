#!/bin/bash
# you need to run the script with sudo, so
if [ "$EUID" -ne 0 ]; then
  echo "run this with sudo."
  exec sudo "$0" "$@"
  exit
fi
User="myapiuser"
Log_dir="/home/logs"
setfacl -R -m u:"$User":rw "$Log_dir"
setfacl -d -m u:"$User":rw "$Log_dir"
