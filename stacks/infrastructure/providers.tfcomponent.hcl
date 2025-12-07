required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = ">= 6.25.0"
  }
}

provider "aws" "main" {
  config {
    region = "us-east-1"
    
  }
}