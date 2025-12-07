# VPC Component - deploys first
component "vpc" {
  source = "../../terraform/modules/vpc"

  inputs = {
    project_name         = "feedback-app"
    vpc_cidr            = "10.0.0.0/16"
    availability_zones   = ["us-east-1a", "us-east-1b"]
    public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]
    enable_nat_gateway   = true
    single_nat_gateway   = true
  }

  providers = {
    aws = provider.aws.main
  }
}

# Security Groups Component - depends on VPC
component "security_groups" {
  source = "../../terraform/modules/security_groups"

  inputs = {
    project_name = "feedback-app"
    vpc_id       = component.vpc.vpc_id
  }

  providers = {
    aws = provider.aws.main
  }
}

# EKS Component - depends on VPC
component "eks" {
  source = "../../terraform/modules/eks"

  inputs = {
    cluster_name            = "app-"
    cluster_version         = "1.34"
    vpc_id                  = component.vpc.vpc_id
    private_subnet_ids      = component.vpc.private_subnets
    node_instance_types     = ["t3.small"]
    node_group_min_size     = 2
    node_group_max_size     = 4
    node_group_desired_size = 2
    project_name            = "feedback-app"
  }

  providers = {
    aws = provider.aws.main
  }
}