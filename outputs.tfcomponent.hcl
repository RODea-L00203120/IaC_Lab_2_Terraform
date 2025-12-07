output "regional_vpcs" {
  description = "VPC IDs by region"
  type        = map(string)
  value = {
    for k, vpc in component.vpc : k => vpc.vpc_id
  }
}

output "cluster_names" {
  description = "EKS cluster names by region"
  type        = map(string)
  value = {
    for k, cluster in component.eks : k => cluster.cluster_name
  }
}

output "cluster_endpoints" {
  description = "EKS cluster endpoints by region"
  type        = map(string)
  value = {
    for k, cluster in component.eks : k => cluster.cluster_endpoint
  }
}

output "kubeconfig_commands" {
  description = "Commands to configure kubectl for each cluster"
  type        = map(string)
  value = {
    for k, cluster in component.eks : 
      k => "aws eks update-kubeconfig --region ${var.regions[k].region} --name ${cluster.cluster_name}"
  }
}

output "s3_bucket" {
  description = "S3 bucket for feedback submissions"
  type        = string
  value       = component.s3.s3_bucket_id
}

output "s3_bucket_region" {
  description = "S3 bucket region"
  type        = string
  value       = "us-east-1"
}
