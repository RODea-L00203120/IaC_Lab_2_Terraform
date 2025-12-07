terraform {
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
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

# Regional AWS providers (for VPC and EKS)
provider "aws" "configurations" {
  for_each = var.regions
  
  config {
    region     = each.value.region
    access_key = var.aws_access_key_id
    secret_key = var.aws_secret_access_key
  }
}

# Dedicated provider for S3 bucket in us-east-1
provider "aws" "s3" {
  config {
    region     = "us-east-1"
    access_key = var.aws_access_key_id
    secret_key = var.aws_secret_access_key
  }
}

# Utility providers
provider "tls" "this" {}
provider "cloudinit" "this" {}
provider "time" "this" {}
provider "null" "this" {}
