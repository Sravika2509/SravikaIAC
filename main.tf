# Define the AWS provider with your credentials and desired region.
provider "aws" {
  region = "us-east-1"  # Modify this to your desired AWS region
}

# Create EC2 instances in the default VPC.
resource "aws_instance" "my_instances" {
  count = 8

  ami           = "ami-053b0d53c279acc90"  # Modify this to your desired AMI
  instance_type = "t2.micro"  # Modify this to your desired instance type

  associate_public_ip_address = true  # Assign public IP addresses

  # Associate the instances with the security group
  security_groups = [aws_security_group.my_security_group.name]
  
  key_name = "id_rsa"  # Replace with your SSH key pair name

  tags = {
    Name = "databaseserver-${count.index + 1}"
  }
}

# Create a security group allowing inbound SSH and other necessary ports.
resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "Allow SSH and other necessary ports"

  # Define your ingress rules here.
  # Example: allow SSH traffic from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Output the public IP addresses and key file.
output "public_ips" {
  value = aws_instance.my_instances[*].public_ip
}




