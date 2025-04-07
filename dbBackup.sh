#!/bin/bash

CURRENT_DIR=$(pwd)
BACKUP_DIR="$CURRENT_DIR/backups"
BACKUP_FILE="$BACKUP_DIR/backup_$(date +%Y_%m_%d_%H_%M_%S).sql"

mkdir -p $BACKUP_DIR

set -a
  source deploy.env
set +a

export PGPASSWORD=$POSTGRES_PASSWORD
pg_dump -U $POSTGRES_USER -h postgres_db $POSTGRES_DB > $BACKUP_FILE

if [ $? -eq 0 ]; then
  echo "Backup created successfully at $BACKUP_FILE"
else
  echo "Backup failed" >&2
fi

# Remove backups older than 90 days
find backups -type f -name "*.sql" -mtime +90 -exec sh -c 'echo "Deleting {}"; rm {}' \;
