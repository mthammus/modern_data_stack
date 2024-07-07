#!/bin/bash

# Navigate to the airbyte/docker directory and start the Docker Compose service
cd airbyte
docker compose stop

# Navigate to the parent directory and then to docker/docker directory, then start the Docker Compose service
cd ..
docker compose stop
docker stop superset

echo "All services have been stopped."