#!/bin/bash

DEPLOY_ENV_PATH=${1:-"./deploy.env"}
if [ ! -f "$DEPLOY_ENV_PATH" ]; then
  echo "Error: deploy.env file not found at $DEPLOY_ENV_PATH" >&2
  exit 1
fi

CURRENT_DIR=$(pwd)
BACKUP_DIR="$CURRENT_DIR/backups"
BACKUP_FILE="$BACKUP_DIR/backup_$(date +%Y_%m_%d_%H_%M_%S).sql"

mkdir -p $BACKUP_DIR

# Load environment variables from the specified deploy.env file
set -a
  source "$DEPLOY_ENV_PATH"
set +a

export PGPASSWORD=$POSTGRES_PASSWORD
pg_dump -U $POSTGRES_USER -h localhost $POSTGRES_DB > $BACKUP_FILE

if [ $? -eq 0 ]; then
  echo "Backup created successfully at $BACKUP_FILE"
else
  echo "Backup failed" >&2
fi

# Remove backups older than 90 days
find $BACKUP_DIR -type f -name "*.sql" -mtime +90 -exec sh -c 'echo "Deleting {}"; rm {}' \;
