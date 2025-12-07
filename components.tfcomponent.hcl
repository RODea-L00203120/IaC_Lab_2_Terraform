# VPC Component - Creates networking infrastructure in each region
component "vpc" {
  for_each = var.regions
  
  source = "terraform-aws-modules/vpc/aws"
  version = "6.5.0"
  
  inputs = {
    name = "feedback-app-vpc-${each.key}"
    cidr = each.value.vpc_cidr
    
    azs             = each.value.azs
    public_subnets  = [
      cidrsubnet(each.value.vpc_cidr, 8, 1),  # 10.X.1.0/24
      cidrsubnet(each.value.vpc_cidr, 8, 2),  # 10.X.2.0/24
    ]
    private_subnets = [
      cidrsubnet(each.value.vpc_cidr, 8, 10), # 10.X.10.0/24
      cidrsubnet(each.value.vpc_cidr, 8, 20), # 10.X.20.0/24
    ]
    
    enable_nat_gateway   = true
    single_nat_gateway   = true  # Cost optimization
    enable_dns_hostnames = true
    enable_dns_support   = true
    
    # Tags for EKS
    public_subnet_tags = {
      "kubernetes.io/role/elb" = 1
      "kubernetes.io/cluster/app-stack-${each.key}" = "shared"
    }
    
    private_subnet_tags = {
      "kubernetes.io/role/internal-elb" = 1
      "kubernetes.io/cluster/app-stack-${each.key}" = "shared"
    }
    
    tags = {
      Project   = "feedback-app"
      Region    = each.key
      StudentID = "L00203120"
    }
  }
  
  providers = {
    aws = provider.aws.configurations[each.key]
  }
}

# EKS Component - Creates Kubernetes clusters in each region
component "eks" {
  for_each = var.regions
  
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"
  
  inputs = {
    cluster_name    = "app-stack-${each.key}"
    cluster_version = var.cluster_version
    
    vpc_id                   = component.vpc[each.key].vpc_id
    subnet_ids               = component.vpc[each.key].private_subnets
    control_plane_subnet_ids = component.vpc[each.key].private_subnets
    
    cluster_endpoint_public_access  = true
    cluster_endpoint_private_access = true
    
    enable_cluster_creator_admin_permissions = true
    
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
        configuration_values = jsonencode({
          enableNetworkPolicy = "true"
          env = {
            ENABLE_PREFIX_DELEGATION = "true"
            WARM_PREFIX_TARGET      = "1"
          }
        })
      }
      eks-pod-identity-agent = {
        most_recent    = true
        before_compute = true
      }
    }
    
    eks_managed_node_groups = {
      initial = {
        name           = "app-stack-${each.key}-nodes"
        instance_types = var.node_instance_types
        
        min_size     = var.node_count
        max_size     = var.node_count * 2
        desired_size = var.node_count
        
        subnet_ids = component.vpc[each.key].private_subnets
        
        tags = {
          Project    = "feedback-app"
          Region     = each.key
          NodeGroup  = "initial"
          StudentID  = "L00203120"
        }
      }
    }
    
    tags = {
      Project   = "feedback-app"
      Region    = each.key
      StudentID = "L00203120"
    }
  }
  
  providers = {
    aws       = provider.aws.configurations[each.key]
    tls       = provider.tls.this
    cloudinit = provider.cloudinit.this
    time      = provider.time.this
    null      = provider.null.this
  }
  
  depends_on = [
    component.vpc
  ]
}

# S3 Component - Global submission storage bucket
component "s3" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"
  
  inputs = {
    bucket = "feedback-app-submissions-l00203120"
    
    versioning = {
      enabled = true
    }
    
    server_side_encryption_configuration = {
      rule = {
        apply_server_side_encryption_by_default = {
          sse_algorithm = "AES256"
        }
      }
    }
    
    lifecycle_rule = [
      {
        id      = "expire-old-submissions"
        enabled = true
        expiration = {
          days = 90
        }
      }
    ]
    
    cors_rule = [
      {
        allowed_headers = ["*"]
        allowed_methods = ["GET", "PUT", "POST"]
        allowed_origins = ["*"]
        expose_headers  = ["ETag"]
        max_age_seconds = 3000
      }
    ]
    
    tags = {
      Project   = "feedback-app"
      StudentID = "L00203120"
    }
  }
  
  providers = {
    aws = provider.aws.s3
  }
}
