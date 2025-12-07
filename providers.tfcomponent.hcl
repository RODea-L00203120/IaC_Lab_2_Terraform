required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 6.25"
  }
  tls = {
    source  = "hashicorp/tls"
    version = "~> 4.0"
  }
  cloudinit = {
    source  = "hashicorp/cloudinit"
    version = "~> 2.3"
  }
  time = {
    source  = "hashicorp/time"
    version = "~> 0.13"
  }
}

# Multi-region providers for VPC/EKS
provider "aws" "configurations" {
  for_each = var.regions

  config {
    region = each.value.region
    
    default_tags {
      tags = {
        Project   = "IaC-Lab-2-Stacks"
        ManagedBy = "Terraform-Stacks"
        Student   = "L00203120"
        Region    = each.value.region
      }
    }
  }
}

# Dedicated provider for S3 bucket (explicit region) one region for access - though not as robust
provider "aws" "s3" {
  config {
    region = "us-east-1"  # Explicit region for S3
    
    default_tags {
      tags = {
        Project   = "IaC-Lab-2-Stacks"
        ManagedBy = "Terraform-Stacks"
        Student   = "L00203120"
        Purpose   = "S3-Storage"
      }
    }
  }
}

provider "tls" "this" {}
provider "cloudinit" "this" {}
provider "time" "this" {}