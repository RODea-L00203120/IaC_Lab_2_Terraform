output "instance_ids" {
  description = "List of EC2 instance IDs"
  value       = aws_instance.web[*].id
}

output "public_ips" {
  description = "List of EC2 public IPs"
  value       = aws_instance.web[*].public_ip
}

output "private_ips" {
  description = "List of EC2 private IPs"
  value       = aws_instance.web[*].private_ip
}