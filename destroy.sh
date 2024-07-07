#!/bin/bash

# Stop and remove the Superset container
docker stop superset
docker rm superset

# Stop and remove Portainer container
sudo docker stop portainer
sudo docker rm portainer

# Remove Portainer Docker volume
sudo docker volume rm portainer_data

# Stop and remove all Airbyte containers
cd data_stack/airbyte
docker compose down
cd ..

# Stop and remove data stack services
docker compose down

# Remove Docker Compose
sudo rm /usr/local/lib/docker/cli-plugins/docker-compose

# Remove data stack directory
rm -rf data_stack

# Stop and disable Nginx
sudo systemctl stop nginx
sudo systemctl disable nginx

# Remove Nginx
sudo yum remove nginx -y

# Remove Docker and its dependencies
sudo yum remove docker -y
sudo yum remove docker-client -y
sudo yum remove docker-client-latest -y
sudo yum remove docker-common -y
sudo yum remove docker-latest -y
sudo yum remove docker-latest-logrotate -y
sudo yum remove docker-logrotate -y
sudo yum remove docker-engine -y

# Remove Python3 and pip
sudo yum remove python3-pip -y

# Remove git
sudo yum remove git -y

# Remove the Docker group from ec2-user
sudo gpasswd -d ec2-user docker

# Remove all Docker data
sudo rm -rf /var/lib/docker

# Remove any remaining Docker directories
sudo rm -rf /usr/local/lib/docker

# Clean up any remaining packages
sudo yum autoremove -y

# Clean up package cache
sudo yum clean all
