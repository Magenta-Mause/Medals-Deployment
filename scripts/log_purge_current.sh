#/bin/bash

# Syntax: ./log_purge_current.sh [container_id]
current_time=$(date --utc +"%Y-%m-%dT%H:%M:%S.%NZ")
echo "Purging all logs for container $1 before timestamp $current_time"
./log_purge_before.sh $1 $current_time
echo "Done."
