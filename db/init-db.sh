#!/bin/bash

# Ensure that DB_PASSWORD has the correct value
# export DB_PASSWORD=<PASSWORD>

# Check if DB_PASSWORD is set
if [ -z "$DB_PASSWORD" ]; then
  echo "Error: DB_PASSWORD environment variable is not set."
  exit 1
fi

# Check if at least one file was provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 file1.sql file2.sql ... fileN.sql"
    exit 1
fi

# Loop through all the files provided as arguments
for file in "$@"
do
    # Check if the file exists
    if [ -f "$file" ]; then
        echo "Processing $file..."
        # Run the psql command
        PGPASSWORD="$DB_PASSWORD" psql --host 127.0.0.1 -U ba-user -d coworking-space-db -p 5433 -f "$file"
        
        # Check if the command was successful
        if [ $? -ne 0 ]; then
            echo "Error processing $file"
        else
            echo "$file processed successfully"
        fi
    else
        echo "File $file does not exist."
    fi
done