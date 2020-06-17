provider "aws" {
  region = "ap-south-1"
  profile = "saurabh"
}

resource "aws_security_group" "allow_connection" {
  name        = "allowConnection"
  description = "Allow SSH and HTTP over inbound traffic"
  vpc_id      = "vpc-d71807bf"

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allowConnections"
  }
}
