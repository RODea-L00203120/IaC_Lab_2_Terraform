# Regional configuration map
variable "regions" {
  type = map(object({
    region   = string
    vpc_cidr = string
    azs      = list(string)
  }))
  default = {
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
}

# Cluster configuration
variable "cluster_version" {
  type    = string
  default = "1.34"
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.small"]
}

variable "node_count" {
  type    = number
  default = 2
}

# AWS Credentials (from variable set)
variable "aws_access_key_id" {
  type      = string
  sensitive = true
  ephemeral = true
}

variable "aws_secret_access_key" {
  type      = string
  sensitive = true
  ephemeral = true
}
