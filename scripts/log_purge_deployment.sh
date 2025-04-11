#/bin/bash

# Syntax: ./log_purge_deployment.sh

containers=$(docker ps -q --filter "label=com.docker.compose.project=medals-deployment")

for container in $containers; do
    full_hash=$(docker inspect --format '{{.Id}}' $container)
    ./log_purge_current.sh $full_hash
done