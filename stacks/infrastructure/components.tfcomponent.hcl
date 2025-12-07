# VPC Component
component "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.5"
  
  providers = {
    aws = provider.aws.default
  }
  
  inputs = {
    name = "feedback-app-vpc"
    cidr = "10.0.0.0/16"
    
    azs             = ["us-east-1a", "us-east-1b"]
    public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets = ["10.0.10.0/24", "10.0.20.0/24"]
    
    enable_nat_gateway = true
    single_nat_gateway = true
    
    enable_dns_hostnames = true
    enable_dns_support   = true
    
    tags = {
      Project   = "IaC-Lab-2"
      StudentID = "L00203120"
      Terraform = "true"
    }
  }
}

# EKS Component
component "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.10.1"
  
  providers = {
    aws       = provider.aws.default
    cloudinit = provider.cloudinit.default
    time      = provider.time.default
    tls       = provider.tls.default
    null      = provider.null.default
  }
  
  inputs = {
    cluster_name    = "app-stack-test"
    cluster_version = "1.34"
    
    vpc_id                   = component.vpc.vpc_id
    subnet_ids               = component.vpc.private_subnets
    control_plane_subnet_ids = component.vpc.private_subnets
    
    endpoint_public_access  = true
    endpoint_private_access = true
    
    cluster_addons = {
      coredns = {
        most_recent = true
      }
      kube-proxy = {
        most_recent = true
      }
      vpc-cni = {
        most_recent    = true
        before_compute = true
      }
      eks-pod-identity-agent = {
        most_recent    = true
        before_compute = true
      }
    }
    
    enable_cluster_creator_admin_permissions = true
    
    eks_managed_node_groups = {
      initial = {
        name = "app-stack-test-node-group"
        
        ami_type       = "AL2023_x86_64_STANDARD"
        instance_types = ["t3.small"]
        
        min_size     = 2
        max_size     = 4
        desired_size = 2
        
        subnet_ids = component.vpc.private_subnets
        
        tags = {
          Project   = "IaC-Lab-2"
          NodeGroup = "initial"
          StudentID = "L00203120"
        }
      }
    }
    
    tags = {
      Name      = "app-stack-test"
      Project   = "IaC-Lab-2"
      StudentID = "L00203120"
      Terraform = "true"
    }
  }
}

# S3 Bucket for Feedback Storage
component "feedback_bucket" {
  source = "./modules/s3"
  
  providers = {
    aws = provider.aws.default
  }
  
  inputs = {
    bucket_name = "feedback-app-submissions-l00203120"
    
    tags = {
      Project   = "IaC-Lab-2"
      Purpose   = "Anonymous Feedback"
      StudentID = "L00203120"
    }
  }
}
