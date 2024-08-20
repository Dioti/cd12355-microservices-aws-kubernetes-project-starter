#!/bin/bash

# Ensure that POSTGRES_PASSWORD has the correct value
# export POSTGRES_PASSWORD=<PASSWORD>

# Check if DB_PASSWORD is set
if [ -z "$POSTGRES_PASSWORD" ]; then
  echo "Error: POSTGRES_PASSWORD environment variable is not set."
  exit 1
fi

# Set environment variables
export DB_USERNAME=ba-user
export DB_PASSWORD=${POSTGRES_PASSWORD}
export DB_HOST=127.0.0.1
export DB_PORT=5433
export DB_NAME=coworking-space-db

# Print out evnironment variables
echo "DB_USERNAME: $DB_USERNAME"
if [ -z "$DB_PASSWORD" ]; then
    echo "DB_PASSWORD: "
else
    echo "DB_PASSWORD: *****"
fi
echo "DB_HOST: $DB_HOST"
echo "DB_PORT: $DB_PORT"
echo "DB_NAME: $DB_NAME"

# Run the Python script
python app.py