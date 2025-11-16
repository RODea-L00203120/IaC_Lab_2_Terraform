module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.5.0"

  name = "${var.project_name}-vpc"
  cidr = var.vpc_cidr

  azs            = var.availability_zones
  public_subnets = var.public_subnet_cidrs

  tags = {
    Name = "${var.project_name}-vpc"
  }
}