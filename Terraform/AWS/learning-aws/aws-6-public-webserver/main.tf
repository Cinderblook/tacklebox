#Github tutorial: https://github.com/chefgs/terraform_repo/tree/master/aws_web_tier
#Site tutorial: https://dev.to/chefgs/create-apache-web-server-in-aws-using-terraform-1fpj

#Terraform Setup Data
terraform {
  #Configure Terraform to search for AWS, Set version, Source
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}
#Configure AWS Provider
provider "aws" {
  region                  = var.active_region
  shared_credentials_file = "%USERPROFILE%.aws/credentials"
  profile                 = "default"
}
# Create a VPC
resource "aws_vpc" "app_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "Web-app-vpc"
  }
}
# Create a gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "vpc_igw"
  }
}
#Create Network route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_rt"
  }
}
# Create a subnet within the CIDR
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone

  tags = {
    Name = "AWS-public-subnet"
  }
}
#Associate Route Table with Subnet created
resource "aws_route_table_association" "public_rt_asso" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
#Create and assign a Security Group. Allow Ports 22, 80, 443
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.app_vpc.id

  ingress {
    #Allow all HTTPS traffic in 
    description = "HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    #Allow all HTTP traffic in 
    description = "HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    #Allow all SSH traffic in 
    description = "SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    #Allow all traffic out
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Allow_Web_Traffic"
  }
}
#Create Network Interface to assign IP
resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.public_subnet.id
  private_ips     = ["10.0.10.50"]
  security_groups = [aws_security_group.allow_web.id]

  #attachment {
  # instance     = aws_instance.test.id
  # device_index = 1
  #}
}
#Assign statiic IP to network interface created
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.10.50"
  depends_on                = [aws_internet_gateway.igw]
}
#Define aws_instance that will be created and ran
resource "aws_instance" "web_server_instance" {
  ami               = var.instance_id01
  instance_type     = var.instance_type01
  availability_zone = var.availability_zone
  key_name          = var.instance_key

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  }
  #Assign commands to be ran on linux machine at boot-up
  user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing apache2"
  sudo apt update -y
  sudo apt install apache2 -y
  echo "*** Completed Installing apache2"
  sudo systemctl start apache2
  sudo bash -c 'echo First Terraform web server "<img src="https://i.pinimg.com/736x/70/f0/5c/70f05c373028626a74824af9a3a6da45--bulldog-franc%C3%A9s-animal-portraits.jpg" alt="BullCop">" > /var/www/html/index.html'
  EOF

  tags = {
    Name = var.instance_name01
  }

  volume_tags = {
    Name = "web_instance"
  }
}

