output "web1_id" {
  description = "Web server 1 instance ID"
  value       = aws_instance.web1.id
}

output "web2_id" {
  description = "Web server 2 instance ID"
  value       = aws_instance.web2.id
}

output "web1_public_ip" {
  description = "Web server 1 public IP"
  value       = aws_instance.web1.public_ip
}

output "web2_public_ip" {
  description = "Web server 2 public IP"
  value       = aws_instance.web2.public_ip
}
