FROM postgres:17
COPY backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh
# Rerun backup every 7 days (604800 seconds)
CMD ["sh", "-c", "while true; do /usr/local/bin/backup.sh; sleep 604800; done"]
