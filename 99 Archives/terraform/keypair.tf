# Key Pair
resource "aws_key_pair" "modern_data_stack_keypair" {
  key_name   = var.ec2_keypair
  public_key = file("~/.ssh/id_rsa.pub")  # Ensure this path is correct
  #public_key = file("~/.ssh/id_rsa.pub")  # For a different key pair use the new key pair file name and location
}