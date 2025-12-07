# VPC component - rolled back to ~>5.0 to solve region/name issues
component "vpc" {
  for_each = var.regions
  
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"
  
  inputs = {
    name = "feedback-app-vpc-${each.key}"
    cidr = each.value.vpc_cidr
    
    azs             = each.value.azs
    public_subnets  = [
      cidrsubnet(each.value.vpc_cidr, 8, 1),
      cidrsubnet(each.value.vpc_cidr, 8, 2),
    ]
    private_subnets = [
      cidrsubnet(each.value.vpc_cidr, 8, 10),
      cidrsubnet(each.value.vpc_cidr, 8, 20),
    ]
    
    enable_nat_gateway   = true
    single_nat_gateway   = true
    enable_dns_hostnames = true
    enable_dns_support   = true
    
    public_subnet_tags = {
      "kubernetes.io/role/elb" = "1"
      "kubernetes.io/cluster/app-stack-${each.key}" = "shared"
    }
    
    private_subnet_tags = {
      "kubernetes.io/role/internal-elb" = "1"
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

# EKS component creates Kubernetes 1.31 cluster 
# with managed node groups in private subnets per region
component "eks" {
  for_each = var.regions
  
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"
  
  inputs = {
    cluster_name    = "app-stack-${each.key}"
    cluster_version = var.cluster_version
    
    vpc_id     = component.vpc[each.key].vpc_id
    subnet_ids = component.vpc[each.key].private_subnets
    
    cluster_endpoint_public_access = true
    enable_cluster_creator_admin_permissions = true
    
    cluster_addons = {
      coredns = {
        most_recent = true
      }
      kube-proxy = {
        most_recent = true
      }
      vpc-cni = {
        most_recent = true
      }
    }
    
    eks_managed_node_groups = {
      initial = {
        name           = "nodes-${each.key}"
        instance_types = var.node_instance_types
        
        min_size     = var.node_count
        max_size     = var.node_count * 2
        desired_size = var.node_count
        
        tags = {
          Project   = "feedback-app"
          NodeGroup = "initial"
          StudentID = "L00203120"
        }
      }
    }
    
    tags = {
      Project   = "feedback-app"
      Region    = each.key
      StudentID = "L00203120"
    }
  }
  
# These were required for terraform stacks init to run
  providers = {
    aws       = provider.aws.configurations[each.key]
    tls       = provider.tls.default
    cloudinit = provider.cloudinit.default
    time      = provider.time.default
    null      = provider.null.default
  }
  # don't create until VPC configured
  depends_on = [component.vpc]
}

# This wasn't really integrated due to time constraints but exists with working app in mind
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
    
    tags = {
      Project   = "feedback-app"
      StudentID = "L00203120"
    }
  }
  
  providers = {
    aws = provider.aws.s3
  }
}
