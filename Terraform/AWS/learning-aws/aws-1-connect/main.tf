#https://cloudskills.io/blog/terraform-aws-1
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.7"
    }
  }
}

provider "aws" {
  profile = "default"
  region = "us-east-1"
}

resource "aws_s3_bucket" "bucket1" {
#Bucket ID must be Globally Unique
  bucket = "my-tf-test-bucket498752"
  acl    = "private"
}