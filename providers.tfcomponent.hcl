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
    region     = each.value.region
    access_key = var.aws_access_key_id
    secret_key = var.aws_secret_access_key
  }
}

provider "aws" "s3" {
  config {
    region     = "us-east-1"
    access_key = var.aws_access_key_id
    secret_key = var.aws_secret_access_key
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
