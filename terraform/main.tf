terraform {
  required_version = ">= 1.13.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.21.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "IaC-Lab-2"
      ManagedBy = "Terraform"
      Student   = "L00203120"
    }
  }
}


module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
}

# Security Groups Module
module "security_groups" {
  source = "./modules/security_groups"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}


# module "ec2" {
#  source = "./modules/ec2"

#  project_name       = var.project_name
#  instance_count     = 2
#  instance_type      = "t3.micro"
#  subnet_ids         = module.vpc.public_subnets
#  availability_zones = var.availability_zones
#  security_group_id  = module.security_groups.ec2_sg_id

#  user_data = templatefile("${path.root}/../app/user_data.sh", {
#    flask_app_code = file("${path.root}/../app/app.py")
#  })
# }

# EKS Cluster Module
module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  node_instance_types     = var.node_instance_types
  node_group_min_size     = var.node_group_min_size
  node_group_max_size     = var.node_group_max_size
  node_group_desired_size = var.node_group_desired_size

  project_name = var.project_name

  depends_on = [module.vpc]
}