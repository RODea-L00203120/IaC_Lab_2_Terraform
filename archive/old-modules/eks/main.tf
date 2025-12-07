module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name    = var.cluster_name
  kubernetes_version = var.cluster_version

  # Networking
  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnet_ids
  control_plane_subnet_ids = var.private_subnet_ids

  # Cluster endpoint access
  endpoint_public_access  = true
  endpoint_private_access = true

  # Cluster addons
  addons = {
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

  # EKS Managed Node Groups
  eks_managed_node_groups = {
    initial = {
      name = "${var.cluster_name}-node-group"

      # AL2023 is default for 1.30+
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = var.node_instance_types

      min_size     = var.node_group_min_size
      max_size     = var.node_group_max_size
      desired_size = var.node_group_desired_size

      # Distribute across private subnets (multi-AZ)
      subnet_ids = var.private_subnet_ids

      tags = {
        Project    = var.project_name
        NodeGroup  = "initial"
        StudentID  = "L00203120"
      }
    }
  }

  tags = {
    Name      = var.cluster_name
    Project   = var.project_name
    StudentID = "L00203120"
    Terraform = "true"
  }
}