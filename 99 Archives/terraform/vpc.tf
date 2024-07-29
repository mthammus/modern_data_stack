# VPC
resource "aws_vpc" "modern_data_stack_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = var.vpc_name
    }
}

# Public Subnet
resource "aws_subnet" "modern_data_stack_subnet" {
  vpc_id                  = aws_vpc.modern_data_stack_vpc.id
  cidr_block              = var.subnet_cidr
  availability_zone       = "us-east-2a" # Change to your desired AZ
  map_public_ip_on_launch = true

  tags = {
    Name        = var.subnet_name
    }
}

# Internet Gateway
resource "aws_internet_gateway" "modern_data_stack_IGW" {
  vpc_id = aws_vpc.modern_data_stack_vpc.id

  tags = {
    Name        = var.igw_name
    }
}

# Public Route Table
resource "aws_route_table" "modern_data_stack_rt" {
  vpc_id = aws_vpc.modern_data_stack_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.modern_data_stack_IGW.id
  }

  tags = {
    Name        = var.igw_name
    }
}

# Public Route Table Association
resource "aws_route_table_association" "modern_data_stack_assoc" {
  subnet_id      = aws_subnet.modern_data_stack_subnet.id
  route_table_id = aws_route_table.modern_data_stack_rt.id

}


# create a new security group open to http traffic and SSH
resource "aws_security_group" "modern_data_stack_sg" {
    name = "modern_data_stack_sg"
    vpc_id = aws_vpc.modern_data_stack_vpc.id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["76.186.132.151/32"]
        description = "nginx"
    }

    ingress {
        from_port   = 9443
        to_port     = 9443
        protocol    = "tcp"
        cidr_blocks = ["76.186.132.151/32"]
        description = "portainer"
    }

    ingress {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = ["76.186.132.151/32"]
        description = "postgres"
    }


    ingress {
        from_port   = 8000
        to_port     = 8000
        protocol    = "tcp"
        cidr_blocks = ["76.186.132.151/32"]
        description = "airbyte"
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["76.186.132.151/32"]
        description = "SSH from Local System"
    }

    ingress {
        from_port   = 7001
        to_port     = 7001
        protocol    = "tcp"
        cidr_blocks = ["76.186.132.151/32"]
        description = "minio"
    }

    ingress {
        from_port   = 9047
        to_port     = 9047
        protocol    = "tcp"
        cidr_blocks = ["76.186.132.151/32"]
        description = "dremio"
    }

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]#["76.186.132.151/32"]
        description = "superset"
    }

    ingress {
        from_port   = 5000
        to_port     = 5000
        protocol    = "tcp"
        cidr_blocks = ["76.186.132.151/32"]
        description = "dbt docs"
    }

    ingress {
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = ["76.186.132.151/32"]
        description = "dagster"
    }

    ingress {
        from_port   = 8234
        to_port     = 8234
        protocol    = "tcp"
        cidr_blocks = ["76.186.132.151/32"]
        description = "spark notebook"
    }

    ingress {
        from_port   = 19120
        to_port     = 19120
        protocol    = "tcp"
        cidr_blocks = ["76.186.132.151/32"]
        description = "nessie"
    }

    egress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "datadog"
    }
    egress {
        from_port   = 8125
        to_port     = 8125
        protocol    = "udp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "datadog"
    }
    egress {
        from_port   = 10516
        to_port     = 10516
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "datadog"
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}
