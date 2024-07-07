#!/bin/bash

# Function to wait for a container to be healthy
wait_for_container() {
    container_name=$1
    while [ "$(sudo docker inspect -f '{{.State.Health.Status}}' $container_name)" != "healthy" ]; do
        echo "Waiting for $container_name to be healthy..."
        sleep 5
    done
}

# Update all packages
sudo yum update -y

# Install git
sudo yum install git -y

# Install Docker
sudo yum install docker -y

# Start Docker service
sudo systemctl start docker

# Enable Docker to start on boot
sudo systemctl enable docker

# Add ec2-user to the Docker group
sudo usermod -aG docker ec2-user

# Install Python3 and pip
sudo yum install python3-pip -y

# Create directory for Docker CLI plugins
sudo mkdir -p /usr/local/lib/docker/cli-plugins

# Download Docker Compose
sudo curl -SL https://github.com/docker/compose/releases/download/v2.6.0/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose

# Make Docker Compose executable
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# Set appropriate permissions for the Docker directory
sudo chmod -R 755 /usr/local/lib/docker

# Install Nginx
sudo yum install nginx -y

# Create a welcome page for Nginx
echo "<h1>Welcome to Secret Data Stack for Amazing Data Projects</h1>" | sudo tee /usr/share/nginx/html/index.html

# Start Nginx service
sudo systemctl start nginx

# Enable Nginx to start on boot
sudo systemctl enable nginx

# Create a Docker volume for Portainer
sudo docker volume create portainer_data

# Run Portainer container
sudo docker run -d --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce --ssl

# Wait for Portainer to be healthy
wait_for_container portainer

# Create a directory for the data stack
mkdir data_stack

# Navigate into the data stack directory
cd data_stack

# Clone Airbyte from GitHub
git clone --depth=1 https://github.com/airbytehq/airbyte.git

# Switch into Airbyte directory
cd airbyte

# Start Airbyte in the background and log output
nohup ./run-ab-platform.sh > airbyte.log 2>&1 &

# Wait for Airbyte to be healthy (you may need to adjust this based on how Airbyte reports health)
sleep 60

# Navigate back to the data stack directory
cd ..

# Bring up data stack services with Docker Compose
docker compose up -d postgres mongodb minio minio-setup dremio spark dagster dagster-daemon

# Wait for data stack services to be healthy
wait_for_container postgres
wait_for_container mongodb
wait_for_container minio
wait_for_container dremio
wait_for_container spark
wait_for_container dagster
wait_for_container dagster-daemon

# Set up Superset
docker run -d -p 8080:8088 -e "SUPERSET_SECRET_KEY=cHnqm6yfvmwZtJLr4rhkkZQoDKP+Rr+ScSPkXWJBbFYmBVpEeod+njXoRjZbu+801tg=" --name superset apache/superset

# Wait for Superset to be healthy
wait_for_container superset

# Create Superset admin user
docker exec -it superset superset fab create-admin --username mthammu --firstname Manoj --lastname Thammu --email mthammu@terces.io --password SecretDataStack5623#

# Upgrade Superset database
docker exec -it superset superset db upgrade

# Load example data into Superset
docker exec -it superset superset load_examples

# Initialize Superset
docker exec -it superset superset init
