output "ec2_sg_id" {
  description = "EC2 security group ID"
  value       = aws_security_group.ec2.id
}

output "ec2_sg_name" {
  description = "EC2 security group name"
  value       = aws_security_group.ec2.name
}

