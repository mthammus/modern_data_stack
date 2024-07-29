variable "vpc_cidr" {
    description = "value of the CIDR range for the VPC"
    type = string
    default = "10.0.0.0/16"
}

variable "vpc_name" {
    description = "value of the name for the VPC"
    type = string
    default = "modern_data_stack_vpc"
}

variable "subnet_cidr" {
    description = "value of the subnet cidr for the VPC"
    type = string
    default = "10.0.1.0/24"
}

variable "subnet_name" {
    description = "value of the subnet name for the VPC"
    type = string
    default = "modern_data_stack_subnet"
}

variable "igw_name" {
    description = "value of the Internet Gateway for the VPC"
    type = string
    default = "modern_data_stack_IGW"
}

variable "ec2_ami" {
    description = "value of the AMI id for the EC2 Instance"
    type = string
    default = "ami-08be1e3e6c338b037"
}

variable "ec2_name" {
    description = "value of the name  for the EC2 instance"
    type = string
    default = "modern_data_stack"
}

variable "ec2_instance_type" {
    description = "value of the type of EC2 instance"
    type = string
    default = "t2.micro"
}


variable "ec2_keypair" {
    description = "Name of the SSH key pair"
    type = string
    default = "modern_data_stack_keypair"
}
