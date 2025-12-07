variable "role_arn" {
  type        = string
  description = "IAM role ARN for OIDC authentication"
}

variable "identity_token" {
  type        = string
  ephemeral   = true
  description = "JWT token for OIDC authentication"
}

variable "regions" {
  type = map(object({
    region   = string
    vpc_cidr = string
    azs      = list(string)
  }))
  description = "Regional configuration for multi-region deployment"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version"
  default     = "1.31"
}

variable "node_instance_types" {
  type        = list(string)
  description = "Instance types for EKS nodes"
  default     = ["t3.small"]
}

variable "node_count" {
  type        = number
  description = "Number of nodes per region"
  default     = 2
}
