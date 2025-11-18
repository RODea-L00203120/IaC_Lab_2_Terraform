output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = module.vpc.igw_id
}

output "instance_ids" {
  description = "List of EC2 instance IDs"
  value       = module.ec2.instance_ids
}

output "public_ips" {
  description = "List of EC2 public IPs"
  value       = module.ec2.public_ips
}

# Student Information
output "student_credentials" {
  description = "Student identification for project submission"
  value = <<-EOT
  
  ================================
  STUDENT CREDENTIALS
  ================================
  Name:           Ronan O'Dea
  Student Number: L00203120
  Repository:     https://github.com/RODea-L00203120/IaC_Lab_2_Terraform
  Branch:         simple-approach-ec2
  ================================
  
  EOT
}