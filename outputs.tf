output "vpc_cidr" {
  description = "The CIDR our new VPC will be utilizing."
  value       = var.vpc_cidr
}

output "ami" {
  description = "The AMI of the EC2 Instance"
  value       = var.ami
}

output "instance_type" {
  description = "The instance type of the EC2 Instance being created"
  value       = var.instance_type
}