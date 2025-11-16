terraform {
  backend "s3" {
    bucket         = "terraform-s3-l00203120-rod"
    key            = "infrastructure/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}