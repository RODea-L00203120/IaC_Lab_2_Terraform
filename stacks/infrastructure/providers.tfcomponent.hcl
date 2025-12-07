# Required Providers for All Components
required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 6.0"  # Latest 6.x
  }
  cloudinit = {
    source  = "hashicorp/cloudinit"
    version = "~> 2.0"  # Latest 2.x
  }
  time = {
    source  = "hashicorp/time"
    version = "~> 0.13"  # Latest 0.13.x
  }
  tls = {
    source  = "hashicorp/tls"
    version = "~> 4.0"  # Latest 4.x
  }
  null = {
    source  = "hashicorp/null"
    version = "~> 3.0"  # Latest 3.x
  }
}

# AWS Provider Configuration
provider "aws" "default" {
  config {
    region = "us-east-1"
    
    default_tags {
      tags = {
        ManagedBy = "TerraformStacks"
        Student   = "L00203120"
      }
    }
  }
}

# CloudInit Provider
provider "cloudinit" "default" {
  config {}
}

# Time Provider
provider "time" "default" {
  config {}
}

# TLS Provider
provider "tls" "default" {
  config {}
}

# Null Provider
provider "null" "default" {
  config {}
}
