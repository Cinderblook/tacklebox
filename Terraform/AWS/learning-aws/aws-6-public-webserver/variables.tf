#Connection Variables
variable "active_region" {
  type    = string
  default = "us-east-1"
}

#AWS Image Variables
variable "instance_id01" {
  description = "AMI key for instance"
  type        = string
  default     = "ami-04505e74c0741db8d"
}
variable "instance_type01" {
  description = "Instance Type of AMI"
  type        = string
  default     = "t2.micro"
}
variable "instance_name01" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "Web-Server"
}

#AWS Virtual Private Cloud variables
variable "vpc_cidr" {
  description = "Value for Network ID"
  type        = string
  default     = "10.0.0.0/16"
}
variable "public_subnet_cidr" {
  description = "Value for public Subnet Network ID"
  type        = string
  default     = "10.0.10.0/24"
}
variable "availability_zone" {
  description = "Value for default availability zone"
  type        = string
  default     = "us-east-1a"
}

#Set instance Key for SSH connection with instance (This is created in AWS, and is downloaded from AWS. This key must also be within folder that terraform is executed)
variable "instance_key" {
  default = "main-key"
}

