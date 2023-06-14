#!/bin/bash

# Backup script

# Define the source directories to be backed up
source_directories=(
    "/path/to/source1"
    "/path/to/source2"
    "/path/to/source3"
)

# Define the destination directory where backups will be stored
destination_directory="/path/to/backup"

# Define the backup filename prefix
backup_prefix="backup_$(date +'%Y%m%d%H%M%S')"

# Create a backup directory with the current timestamp
backup_directory="$destination_directory/$backup_prefix"
mkdir -p "$backup_directory"

# Backup each source directory to the backup directory
for source_directory in "${source_directories[@]}"; do
    cp -R "$source_directory" "$backup_directory"
done

# Print backup summary
echo "Backup created: $backup_directory"
