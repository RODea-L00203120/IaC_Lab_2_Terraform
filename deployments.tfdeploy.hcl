identity_token "aws" {
  audience = ["aws.workload.identity"]
}

deployment "production" {
  inputs = {
    role_arn       = "arn:aws:iam::820198199907:role/HCP-Terraform-Stacks-Role"
    identity_token = identity_token.aws.jwt
    
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
    
    cluster_version     = "1.31"
    node_instance_types = ["t3.small"]
    node_count          = 2
  }
  destroy = true  # ADD THIS LINE
}
