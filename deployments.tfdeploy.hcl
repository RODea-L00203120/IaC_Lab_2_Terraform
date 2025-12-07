deployment "production" {
  inputs = {
    aws_access_key_id     = var.aws_access_key_id
    aws_secret_access_key = var.aws_secret_access_key
    
    regions = {
      east = {
        region   = "us-east-1"
        vpc_cidr = "10.0.0.0/16"
        azs      = ["us-east-1a", "us-east-1b"]
      }
      west = {
        region   = "us-west-2"
        vpc_cidr = "10.1.0.0/16"
        azs      = ["us-west-2a", "us-west-2b"]
      }
    }
    
    cluster_version      = "1.31"
    node_instance_types  = ["t3.small"]
    node_count          = 2
  }
}

variable "aws_access_key_id" {
  type      = string
  ephemeral = true
}

variable "aws_secret_access_key" {
  type      = string
  sensitive = true
  ephemeral = true
}
