#!/bin/bash
# Step to re-execute the script if needed
if [ "$1" != "second_run" ]; then
    echo "Initial setup started"

    echo "Updating all packages..."
    sudo yum update -y
    echo "Packages updated."

    echo "Installing git..."
    sudo yum install git -y
    echo "Git installed."

    echo "Installing Docker..."
    sudo yum install docker -y
    echo "Docker installed."

    echo "Starting Docker service..."
    sudo systemctl start docker
    echo "Docker service started."

    echo "Enabling Docker to start on boot..."
    sudo systemctl enable docker
    echo "Docker enabled to start on boot."

    echo "Adding ec2-user to the Docker group..."
    sudo usermod -aG docker ec2-user
    echo "ec2-user added to Docker group."

    echo "Installing Python3 and pip..."
    sudo yum install python3-pip -y
    echo "Python3 and pip installed."

    echo "Creating directory for Docker CLI plugins..."
    sudo mkdir -p /usr/local/lib/docker/cli-plugins
    echo "Directory for Docker CLI plugins created."

    echo "Downloading Docker Compose..."
    sudo curl -SL https://github.com/docker/compose/releases/download/v2.6.0/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
    echo "Docker Compose downloaded."

    echo "Making Docker Compose executable..."
    sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
    echo "Docker Compose is now executable."

    echo "Setting appropriate permissions for the Docker directory..."
    sudo chmod -R 755 /usr/local/lib/docker
    echo "Permissions set for Docker directory."

    echo "Installing Nginx..."
    sudo yum install nginx -y
    echo "Nginx installed."

    echo "Creating a welcome page for Nginx..."
    echo "<h1>Welcome to Secret Data Stack for Amazing Data Projects</h1>" | sudo tee /usr/share/nginx/html/index.html
    echo "Welcome page created."

    echo "Starting Nginx service..."
    sudo systemctl start nginx
    echo "Nginx service started."

    echo "Enabling Nginx to start on boot..."
    sudo systemctl enable nginx
    echo "Nginx enabled to start on boot."

    echo "Re-executing script with updated group permissions..."
    exec sg docker "$0 second_run"
    exit
fi

echo "Docker-related operations started"

echo "Creating Docker volume for Portainer..."
docker volume create portainer_data
echo "Docker volume for Portainer created."

echo "Running Portainer container..."
docker run -d -p 6200:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce --ssl
echo "Portainer container started."

echo "Cloning modern data stack repository..."
git clone https://github.com/mthammus/modern_data_stack
echo "Modern data stack repository cloned."

echo "Navigating into the data stack directory..."
cd modern_data_stack
chmod +x *

echo "Cloning Airbyte from GitHub..."
git clone --depth=1 https://github.com/airbytehq/airbyte.git
echo "Airbyte cloned."

echo "Switching into Airbyte directory..."
cd airbyte

echo "Starting Airbyte in the background and logging output..."
nohup ./run-ab-platform.sh > airbyte.log 2>&1 &
echo "Airbyte started."

echo "Navigating back to the data stack directory..."
cd ..

echo "Bringing up data stack services with Docker Compose..."
docker compose up -d postgres mongodb minio minio-setup dremio spark dagster dagster-daemon
echo "Data stack services started."

echo "Setting up Superset..."
docker run -d -p 8080:8088 -e "SUPERSET_SECRET_KEY=cHnqm6yfvmwZtJLr4rhkkZQoDKP+Rr+ScSPkXWJBbFYmBVpEeod+njXoRjZbu+801tg=" --name superset apache/superset
echo "Superset container started."

echo "Waiting for superset"
sleep 120

echo "Creating Superset admin user..."
docker exec -it superset superset fab create-admin --username mthammu --firstname Manoj --lastname Thammu --email mthammu@terces.io --password SecretDataStack5623#
echo "Superset admin user created."

echo "Upgrading Superset database..."
docker exec -it superset superset db upgrade
echo "Superset database upgraded."

echo "Loading example data into Superset..."
docker exec -it superset superset load_examples
echo "Example data loaded into Superset."

echo "Initializing Superset..."
docker exec -it superset superset init
echo "Superset initialized."

echo "Setup completed"
