BACKUP_FILE="/backups/backup_$(date +%Y_%m_%d_%H_%M_%S_).sql"

mkdir backups

export PGPASSWORD=$POSTGRES_PASSWORD
echo $POSTGRES_PASSWORD
echo $POSTGRES_USER
echo $POSTGRES_DB
# pg_dump -U $POSTGRES_USER -h postgres_db -p 5432 $POSTGRES_DB > $BACKUP_FILE
pg_dump -h postgres_db -Fc -U $POSTGRES_USER $POSTGRES_DB > $BACKUP_FILE

if [ $? -eq 0 ]; then
  echo "Backup created successfully at $BACKUP_FILE"
else
  echo "Backup failed" >&2
fi

# Remove backups older than 90 days
find backups -type f -name "*.sql" -mtime +90 -exec sh -c 'echo "Deleting {}"; rm {}' \;
