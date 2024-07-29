# EC2 Instance Setup
resource "aws_instance" "modern_data_stack" {
  ami                     = var.ec2_ami
  instance_type           = var.ec2_instance_type
  subnet_id                         = aws_subnet.modern_data_stack_subnet.id
  vpc_security_group_ids            = [aws_security_group.modern_data_stack_sg.id]
  associate_public_ip_address       = true 
  key_name                          = var.ec2_keypair

  root_block_device {
    volume_size = 50 # New desired size in GB
  }

  user_data = <<-EOD
    #!/bin/bash
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

    # Re-execute script with Docker group permissions
    sudo -u ec2-user -i <<-EOF
        # Ensure Docker group permissions
        newgrp docker

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

        echo "Navigating into the data stack directory and executing commands  to install python env and dbt software and dbt plugins)..."
        cd modern_data_stack
        chmod +x *
        python3 -m venv dbt-env
        source dbt-env/bin/activate
        python3 -m pip install --upgrade pip
        pip install dbt
        mkdir dbt_project
        cd dbt_project
        pip install dagster-dbt
        pip install dbt-dremio
        deactivate
        cd ..        

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
        docker compose up -d postgres mongodb opentelemetry-collector minio minio-setup dremio spark dagster dagster-daemon superset nessie
        echo "Data stack services started."
        sudo chown -R 1000:100 ./spark/spark_data
        sudo chmod -R 775 ./spark/spark_data
        echo "Setup completed"
    EOF
  EOD
  tags = {
    Name = var.ec2_name
  }
}

# Associate the Elastic IP with the EC2 instance
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.modern_data_stack.id
  allocation_id = "eipalloc-026d66290d3353da9"  # Replace with your actual EIP allocation ID
}