BACKUP_FILE="/backups/backup_$(date +%Y_%m_%d_%H_%M_%S_).sql"

mkdir backups

export PGPASSWORD=$POSTGRES_PASSWORD
pg_dump -U $POSTGRES_USER -h postgres_db $POSTGRES_DB > $BACKUP_FILE
echo "Backup created at $BACKUP_FILE"

# Remove backups older than 90 days
# find backups -type f -name "*.sql" -mtime +1 -exec rm {} \;
find backups -type f -name "*.sql" -mmin +1 -exec sh -c 'echo "Deleting {}"; rm {}' \;
