####### VPC ########
vpc_cidr = "10.0.0.0/16"
vpc_name = "modern_data_stack_vpc"

####### Public Subnet ########
subnet_cidr = "10.0.1.0/24"
subnet_name = "modern_data_stack_subnet"

####### Internet Gateway ########
igw_name = "modern_data_stack_igw"

####### EC2 Instance ########
ec2_ami = "ami-08be1e3e6c338b037"
ec2_name = "modern_data_stack"
#ec2_instance_type = "t2.micro"
ec2_instance_type = "m4.2xlarge"
ec2_keypair = "modern_data_stack_keypair"
