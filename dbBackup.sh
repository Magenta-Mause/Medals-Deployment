#!/bin/bash

BACKUP_DIR="/backups"
BACKUP_FILE="$BACKUP_DIR/backup_$(date +%Y_%m_%d_%H_%M_%S).sql"

export PGPASSWORD=$POSTGRES_PASSWORD
pg_dump -U $POSTGRES_USER -h localhost $POSTGRES_DB > $BACKUP_FILE

if [ $? -eq 0 ]; then
  echo "Backup created successfully at $BACKUP_FILE"
else
  echo "Backup failed" >&2
fi

# Remove backups older than 90 days
find "$BACKUP_DIR" -type f -name "*.sql" -mtime +90 -exec sh -c 'echo "Deleting {}"; rm {}' \;
