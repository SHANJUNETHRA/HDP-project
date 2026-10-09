terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Connect Terraform to AWS
provider "aws" {
  region = var.aws_region
}

# Find the latest Ubuntu 24.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# Create a security group
resource "aws_security_group" "pep_sg" {
  name        = "pep-devops-sg"
  description = "Security group for PEP DevOps project"

  # SSH access: replace with your actual public IP
  ingress {
    description = "SSH access from my IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["14.195.132.38/32"]
  }

  # Allow website traffic
  ingress {
    description = "HTTP web traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic for package downloads and other connections
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pep-devops-sg"
  }
}

# Create an EC2 instance
resource "aws_instance" "pep_ec2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.pep_sg.id]

  # Install Docker automatically when EC2 starts
  user_data = file("${path.module}/user-data.sh")

  tags = {
    Name = "PEP-DevOps-EC2"
  }
}

