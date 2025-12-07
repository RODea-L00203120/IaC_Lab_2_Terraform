# Reference AWS credentials from variable set
store "varset" "aws_creds" {
  id       = "varset-EdCqUys7PmwKJRbh"
  category = "env"
}

# Multi-Region Production Deployment
deployment "production" {
  inputs = {
    # Pass credentials from variable set to providers
    aws_access_key_id     = store.varset.aws_creds.AWS_ACCESS_KEY_ID
    aws_secret_access_key = store.varset.aws_creds.AWS_SECRET_ACCESS_KEY
    
    # Regional configuration
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
    cluster_version      = "1.34"
    node_instance_types  = ["t3.small"]
    node_count           = 2
  }
}
