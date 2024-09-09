#!/bin/bash

# Author: Ravi Shankar Rajupalepu
# Date: 2024-09-06
# This script installs the Loki Docker plugin,
# and restarts Docker while preserving the state of running containers.

# Install the Loki Docker plugin
echo "Installing Loki Docker plugin..."
docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions

TEMP_FILE=$(mktemp)

# Get the names of all running containers and store them in the temp file
docker ps --format '{{.Names}}' > "$TEMP_FILE"

echo "Restarting Docker service..."
sudo systemctl restart docker

# Wait a few seconds for Docker to restart
sleep 10

# Read the temporary file and start containers that were stopped
while IFS= read -r container_name; do
  echo "Starting container $container_name..."
  docker start "$container_name"
done < "$TEMP_FILE"

# Remove the temporary file
rm -f "$TEMP_FILE"

echo "Docker service restarted and containers restored."
