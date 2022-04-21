terraform {
  cloud {
    organization = "Ajb52-Projects"
    workspaces {
      name = "Example-Workspace"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.27"
    }
  }
}

provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/home/terraform/.aws/credentials"
  profile                 = "default"
}
# Pull VPC Information
data "aws_vpc" "main" {
  id = "vpc-080b3af0a14fbf9dc"
}

# Create Security group
resource "aws_security_group" "sg_app_server" {
  name        = "sg_app_server"
  description = "My Security Group"
  vpc_id      = data.aws_vpc.main.id
  # HTTP IN
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }
  # HTTPS In
  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }
  # SSH IN
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }
  # Allow traffic out - ALL
  egress {
    description      = "Outgoing Traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }

  tags = {
    Name = "allow_tls"
  }
}

# Create SSH Key to connect to VM
resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  # Generate with ssh-keygen.exe -t rsa
  public_key = "ssh key here"
  }

# Assign userdata.yml file to a datasource
data "template_file" "user_data" {
  template = file("./userdata.yml")
}
# Assign VM (EC2) resources
resource "aws_instance" "app_server" {
  ami                    = "ami-08e4e35cccc6189f4"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.sg_app_server.id]
  user_data              = data.template_file.user_data.rendered

  tags = {
    Name = "ExServer"
  }
}

resource "null_resource" "status" {
  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --region us-east-1 --instance-ids ${aws_instance.app_server.id}"
  }
  depends_on = [aws_instance.app_server]
}

# Spit out public_ip
output "public_ip" {
  value = aws_instance.app_server.public_ip
}