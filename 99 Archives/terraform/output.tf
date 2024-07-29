output "vpc_id" {
    description = "ID of the VPC"
    value = aws_vpc.modern_data_stack_vpc.id
}

output "subnet_id" {
    description = "ID of the Subnet"
    value = aws_subnet.modern_data_stack_subnet.id
}

output "instance_id" {
    description = "ID of the EC2 Instance"
    value = aws_instance.modern_data_stack.id
}

output "instance_public_ip" {
    description = "Public IP address of the EC2 Instance"
    value = aws_eip_association.eip_assoc.public_ip
}

output "portainer_url" {
  value = "https://${aws_eip_association.eip_assoc.public_ip}:9443"
}

output "superset_url" {
  value = "http://${aws_eip_association.eip_assoc.public_ip}:8080"
}

output "dremio_url" {
  value = "http://${aws_eip_association.eip_assoc.public_ip}:9047"
}

output "spark_url" {
  value = "http://${aws_eip_association.eip_assoc.public_ip}:8088"
}

output "minio_url" {
  value = "http://${aws_eip_association.eip_assoc.public_ip}:7001"
}

output "airbyte_url" {
  value = "http://${aws_eip_association.eip_assoc.public_ip}:8000"
}

output "dagster_url" {
  value = "http://${aws_eip_association.eip_assoc.public_ip}:3000"
}

