resource "aws_instance" "app_server" {
  ami           = "ami-08e4e35cccc6189f4"
  instance_type = "t2.micro"
  #vpc_security_group_ids = ["sg-065c32616d271a347"]
  #subnet_id = "subnet-0d0224d17fb5058c8"

  tags = {
    Name = "${local.project_name}"
  }
}

# Terraform AWS Module
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc-module"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
