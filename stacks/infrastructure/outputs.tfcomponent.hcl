output "vpc_id" {
  type  = string
  value = component.vpc.vpc_id
}

output "eks_cluster_name" {
  type  = string
  value = component.eks.cluster_name
}

output "eks_cluster_endpoint" {
  type  = string
  value = component.eks.cluster_endpoint
}

output "configure_kubectl" {
  type  = string
  value = "aws eks update-kubeconfig --region us-east-1 --name ${component.eks.cluster_name}"
}

output "student_info" {
  type  = string
  value = "Deployed by L00203120 using Terraform Stacks v1.14.0"
}
output "feedback_bucket_name" {
  type  = string
  value = component.feedback_bucket.bucket_name
}
