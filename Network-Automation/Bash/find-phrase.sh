#!/bin/bash

# Define the directory where you want to search for files
directory="/path/to/search"

# Search for files containing "Cinderblook.com" and replace with "Cinderblock.tech"
files=$(grep -ril "Phrase-Here" "$directory")
total_files=$(echo "$files" | wc -l)
count=0

echo "Total files: $total_files"

# Loop through each file and perform the replacement
while IFS= read -r file; do
    count=$((count + 1))
    echo -ne "Progress: $count/$total_files\r"
    echo "Found in: $file"
done <<< "$files"

echo "Replacement complete."
