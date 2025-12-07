  
# VPC COMPONENT (Multi-Region)


component "vpc" {
  for_each = var.regions

  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.5"

  inputs = {
    name = "feedback-app-vpc-${each.key}"
    cidr = each.value.vpc_cidr

    azs             = each.value.azs
    public_subnets  = [
      cidrsubnet(each.value.vpc_cidr, 8, 1),
      cidrsubnet(each.value.vpc_cidr, 8, 2)
    ]
    private_subnets = [
      cidrsubnet(each.value.vpc_cidr, 8, 10),
      cidrsubnet(each.value.vpc_cidr, 8, 20)
    ]

    enable_nat_gateway   = true
    single_nat_gateway   = true
    enable_dns_hostnames = true
    enable_dns_support   = true

    public_subnet_tags = {
      "kubernetes.io/role/elb" = 1
    }
    private_subnet_tags = {
      "kubernetes.io/role/internal-elb" = 1
    }

    tags = {
      Region = each.value.region
    }
  }

  providers = {
    aws = provider.aws.configurations[each.key]
  }
}


# EKS COMPONENT (Multi-Region)


component "eks" {
  for_each = var.regions

  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.10"

  inputs = {
    cluster_name    = "app-stack-${each.key}"
    cluster_version = var.cluster_version

    vpc_id                   = component.vpc[each.key].vpc_id
    subnet_ids               = component.vpc[each.key].private_subnets
    control_plane_subnet_ids = component.vpc[each.key].private_subnets

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
        most_recent    = true
        before_compute = true
        configuration_values = jsonencode({
          env = {
            ENABLE_PREFIX_DELEGATION = "true"
            WARM_PREFIX_TARGET       = "1"
          }
        })
      }
      eks-pod-identity-agent = {
        most_recent = true
      }
    }

    eks_managed_node_groups = {
      initial = {
        name           = "app-stack-${each.key}-nodes"
        ami_type       = "AL2023_x86_64_STANDARD"
        instance_types = var.node_instance_types

        min_size     = var.node_count
        max_size     = var.node_count * 2
        desired_size = var.node_count

        subnet_ids = component.vpc[each.key].private_subnets

        tags = {
          NodeGroup = "initial"
          Region    = each.value.region
        }
      }
    }

    tags = {
      Region = each.value.region
    }
  }

  providers = {
    aws       = provider.aws.configurations[each.key]
    tls       = provider.tls.this
    cloudinit = provider.cloudinit.this
    time      = provider.time.this
    null      = provider.null.this
  }
}

# S3 COMPONENT (Single Global Bucket - Explicit Provider)

component "s3" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.9"

  inputs = {
    bucket        = "feedback-app-submissions-l00203120"
    force_destroy = true

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
      Purpose = "Multi-Region-Storage"
    }
  }

  providers = {
    aws = provider.aws.s3  # Uses explicit S3 provider
  }
}