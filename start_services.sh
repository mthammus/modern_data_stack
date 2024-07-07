#!/bin/bash

# Navigate to the airbyte/docker directory and start the Docker Compose service
cd airbyte
docker compose start

# Navigate to the parent directory and then to docker/docker directory, then start the Docker Compose service
cd ..
docker compose start
docker start superset

echo "All services have been started."