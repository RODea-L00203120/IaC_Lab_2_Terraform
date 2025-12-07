required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 4.67"
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
    version = "~> 0.9"
  }
  null = {
    source  = "hashicorp/null"
    version = "~> 3.2"
  }
}

provider "aws" "configurations" {
  for_each = var.regions
  config {
    region = each.value.region
    
    assume_role_with_web_identity {
      role_arn           = var.aws_role_arn
      web_identity_token = identity_token.aws.jwt
    }
  }
}

provider "aws" "s3" {
  config {
    region = "us-east-1"
    
    assume_role_with_web_identity {
      role_arn           = var.aws_role_arn
      web_identity_token = identity_token.aws.jwt
    }
  }
}

provider "tls" "default" {
  config {}
}

provider "cloudinit" "default" {
  config {}
}

provider "time" "default" {
  config {}
}

provider "null" "default" {
  config {}
}
