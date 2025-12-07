variable "aws_access_key_id" {
  type        = string
  description = "AWS Access Key ID"
  ephemeral   = true
}

variable "aws_secret_access_key" {
  type        = string
  description = "AWS Secret Access Key"
  sensitive   = true
  ephemeral   = true
}

variable "regions" {
  type = map(object({
    region   = string
    vpc_cidr = string
    azs      = list(string)
  }))
  description = "Regional configuration"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version"
  default     = "1.31"
}

variable "node_instance_types" {
  type        = list(string)
  description = "Instance types for nodes"
  default     = ["t3.small"]
}

variable "node_count" {
  type        = number
  description = "Number of nodes per region"
  default     = 2
}
