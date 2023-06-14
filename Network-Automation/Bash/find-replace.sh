#!/bin/bash

# Define the directory where you want to search for files
directory="/path/to/search"

# Search for files containing "Cinderblook.com" and replace with "Cinderblock.tech"
files=$(grep -rl "Cinderblook.com" "$directory")
total_files=$(echo "$files" | wc -l)
count=0

echo "Total files: $total_files"

# Loop through each file and perform the replacement
while IFS= read -r file; do
    count=$((count + 1))
    echo -ne "Progress: $count/$total_files\r"

    sed -i 's/Cinderblook\.com/Cinderblock.tech/gI' "$file"
    echo "Modified: $file"
done <<< "$files"

echo "Replacement complete."

# Save file as *.sh
# give it executable 'chmod +x file.sh'
# One Liner option ---> find /path/to/directory -type f -exec sed -i 's/cinderblook\.com/cinderblock.tech/gI' {} +