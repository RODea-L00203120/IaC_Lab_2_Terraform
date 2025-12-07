# Multi-Region Production Deployment
deployment "production" {
  inputs = {
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
