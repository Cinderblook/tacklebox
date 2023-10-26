#!/bin/bash

# Stop all running Docker containers
docker stop $(docker ps -aq)

# Wait for all containers to stop
while [ "$(docker ps -q | wc -l)" -gt 0 ]; do
  echo "Waiting for containers to stop..."
  sleep 5
done

# Create a backup of the home volume
DATESTAMP=$(date +"%Y%m%d-%H%M%S")
HOSTNAME=$(hostname)
BACKUP_FILENAME="${DATESTAMP}-${HOSTNAME}-backup.tar"
tar -czf "$BACKUP_FILENAME" /home/austin/

# Start all Docker containers
docker start $(docker ps -aq)

# Print the location of the backup file
echo "Backup saved to: $BACKUP_FILENAME"