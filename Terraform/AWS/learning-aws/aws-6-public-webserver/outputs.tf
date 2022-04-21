#The Outputs.tf file will allow you to customize returned variables of a terraform script once it is executed.
#Returns ID Name of the instance deployed
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web_server_instance.id
}
#Returns the public IP address of the instance deployed
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web_server_instance.public_ip
}
#Returns the private IP address of the instance deployed
output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.web_server_instance.private_ip
}