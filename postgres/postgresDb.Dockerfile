FROM postgres:17

RUN apt-get update && apt-get install -y \
    cron && \
    rm -rf /var/lib/apt/lists/*

COPY backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh

RUN echo "*/1 * * * * root bash -c 'set -a; source /proc/self/environ; set +a; /usr/local/bin/backup.sh' >> /var/log/backup.log 2>&1" >> /etc/crontab && \
    chmod 0644 /etc/crontab && \
    touch /var/log/backup.log /var/log/cron.log

# Start cron in the foreground
CMD ["postgres"]
# CMD ["sh", "-c", "cron && tail -f /var/log/backup.log & exec postgres"]
