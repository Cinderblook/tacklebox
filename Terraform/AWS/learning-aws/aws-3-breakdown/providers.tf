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
