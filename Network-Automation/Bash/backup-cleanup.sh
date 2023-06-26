#!/bin/bash

# Set the backup directory path
backup_dir="/home/<your-username>/backups"

# Change to the backup directory
cd "$backup_dir" || exit

# Use the find command to locate all backup files and sort them by modification time (newest first)
# Then use tail to skip the latest backups for each server IP and delete the rest
find . -maxdepth 1 -type f -name "*.backup" | awk -F'[-.]' '{print $3 "-" $4 "-" $5 "-" $6}' | sort -r | uniq -d | xargs -I{} find . -type f -name "*{}*" | sort -r | tail -n +2 | xargs -d '\n' rm -f
