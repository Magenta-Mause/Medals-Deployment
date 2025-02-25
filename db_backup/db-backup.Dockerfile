FROM postgres:17
COPY backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh
# Rerun backup every 30 days (2592000 seconds)
CMD ["sh", "-c", "while true; do /usr/local/bin/backup.sh; sleep 40; done"]
