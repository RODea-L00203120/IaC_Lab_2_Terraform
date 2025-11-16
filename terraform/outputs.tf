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

output "web1_public_ip" {
  description = "Web server 1 public IP"
  value       = module.ec2.web1_public_ip
}

output "web2_public_ip" {
  description = "Web server 2 public IP"
  value       = module.ec2.web2_public_ip
}
