provider "aws" {
  region = "us-east-1"  # Modify this to your desired AWS region gg
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"  # Modify this CIDR block as needed
}

resource "aws_subnet" "my_subnet" {
  count             = 8
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = "us-east-1a"  # Modify this to your desired AZ
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_instances" {
  count = 8

  ami           = "ami-05fa00d4c63e32376"  # Modify this to your desired AMI
  instance_type = "t2.micro"  # Modify this to your desired instance type

  subnet_id          = aws_subnet.my_subnet[count.index].id
  security_groups    = [aws_security_group.allow_all.name]

  tags = {
    Name = "server-${count.index + 1}"
  }
}

output "instance_ips" {
  value = aws_instance.my_instances[*].private_ip
}
