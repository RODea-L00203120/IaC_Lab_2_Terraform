required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 5.0"
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

provider "aws" "configurations" {
  for_each = var.regions
  config {
    region = each.value.region
  }
}

provider "aws" "s3" {
  config {
    region = "us-east-1"
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
