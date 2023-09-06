# Define the AWS provider with your credentials and desired region.
provider "aws" {
  region = "us-east-1"  # Modify this to your desired AWS region
}

# Create a VPC.
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"  # Modify this CIDR block as needed
}

# Create subnets in the VPC.
resource "aws_subnet" "my_subnet" {
  count             = 8
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = "us-east-1a"  # Modify this to your desired AZ
}

# Create a security group allowing inbound SSH and other necessary ports.
resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "Allow SSH and other necessary ports"
  vpc_id      = aws_vpc.my_vpc.id

  # Define your ingress rules here.
  # Example: allow SSH traffic from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 instances in the subnets.
resource "aws_instance" "my_instances" {
  count = 8

  ami           = "ami-05fa00d4c63e32376"  # Modify this to your desired AMI
  instance_type = "t2.micro"  # Modify this to your desired instance type

  subnet_id = aws_subnet.my_subnet[count.index].id

  # Associate the instances with the security group
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  
  key_name = aws_key_pair.my_key_pair.key_name

  tags = {
    Name = "server-${count.index + 1}"
  }
}

# Output the private IP addresses of the EC2 instances.
output "instance_ips" {
  value = aws_instance.my_instances[*].private_ip
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "id_rsa"
  public_key=file(".ssh/id_rsa.pub")
}

# Output the private key to a local file.
resource "local_file" "private_key" {
  filename = ".ssh/id_rsa"
  content  = aws_key_pair.my_key_pair.public_key
}


