#!/bin/bash

## Syntax: ./purge_before.sh [container_id] [timestamp]

container_dir=/var/lib/docker/containers/$1
purge_before=$2
in_file=$container_dir/$1-json.log
mask_timestamps=$(jq -s '.' $in_file | jq -r '.[] | .time')
counter=0
tmp=$(mktemp)

for timestamp in $mask_timestamps; do
    if [[ "$timestamp" > "$purge_before" ]]; then
        break
    fi
    counter=$((counter+1))
done

sed -n "${counter},\$p" $in_file > $tmp
mv $tmp $in_file
rm -rf $tmp