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
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  public_subnet_cidrs = var.public_subnet_cidrs
}

module "ec2" {
  source = "./modules/ec2"
  
  project_name       = var.project_name
  instance_count     = 2
  instance_type      = "t3.micro"
  subnet_ids         = module.vpc.public_subnets
  availability_zones = var.availability_zones 
  
 # user_data = templatefile("${path.root}/../app/user_data.sh", {
   # flask_app_code = file("${path.root}/../app/app.py")
#  })
}