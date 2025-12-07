# VPC Outputs
output "vpc_id" {
  type        = string
  value       = component.vpc.vpc_id
  description = "VPC ID"
}

output "public_subnet_ids" {
  type        = list(string)
  value       = component.vpc.public_subnets
  description = "Public subnet IDs"
}

output "private_subnet_ids" {
  type        = list(string)
  value       = component.vpc.private_subnets
  description = "Private subnet IDs"
}

# EKS Outputs
output "eks_cluster_id" {
  type        = string
  value       = component.eks.cluster_id
  description = "EKS cluster ID"
}

output "eks_cluster_endpoint" {
  type        = string
  value       = component.eks.cluster_endpoint
  description = "EKS cluster endpoint"
}

output "eks_cluster_name" {
  type        = string
  value       = component.eks.cluster_name
  description = "EKS cluster name"
}

# S3 Outputs
output "feedback_bucket_id" {
  type        = string
  value       = component.feedback_bucket.s3_bucket_id
  description = "S3 bucket name for feedback storage"
}

output "feedback_bucket_arn" {
  type        = string
  value       = component.feedback_bucket.s3_bucket_arn
  description = "S3 bucket ARN"
}

# Helper Output
output "configure_kubectl" {
  type        = string
  value       = "aws eks update-kubeconfig --region us-east-1 --name ${component.eks.cluster_name}"
  description = "Command to configure kubectl"
}
