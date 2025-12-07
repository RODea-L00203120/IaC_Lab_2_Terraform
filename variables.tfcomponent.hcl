variable "regions" {
  description = "Map of regions for multi-region deployment"
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

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.34"
}

variable "node_instance_types" {
  description = "Instance types for EKS nodes"
  type        = list(string)
  default     = ["t3.small"]
}

variable "node_count" {
  description = "Number of nodes per cluster"
  type        = number
  default     = 2
}