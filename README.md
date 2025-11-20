# IaC_Lab_2_Terraform

Repository in support of academic report for Lab 2's prescribed topic.

This repository provides a means of Version Control and evidences the following:

The authors engagement in practitioner-based research in effort to compose a IaC solution for a hypothetical DevOps pipeline.

- The proposed scenario is the provision of infrastructure for the deployment of a feedback mechanism for employees in an organization.

- While the landing page is simplistic (a form), reliability, security, modularity and scalability are of concern and therefore the underlying architecture design aimed for is as follows:

## Infrastructure Architecture for Stage 2:

To do.

## Stage 2 Design decisions

- Configured HCP Cloud Account to allow for single cluster approach and potentially use terraform stacks.

(insert image)

- Configured private sub-nets using same modular approach as before. Logic is:  `terraform/variables.tf` defines variables passed to `terraform/main.tf` which are passed to  `modules/vpc/main.tf` which are expected as defined in `modules/vpc/variables.tf`. A single NAT gateway is configured to allow next step.

``` HCL
# terraform/main.tf

variable "private_subnet_cidrs" {
  default = ["10.0.10.0/24", "10.0.20.0/24"]
}
variable "enable_nat_gateway" {
  default = true
}
variable "single_nat_gateway" {
  default = true
}

```

- Create EKS Module. Place EKS nodes on private sub-nets with a single NAT configured for access (two best practice but double the cost). 

``` HCL
 # EKS Configuration in `terraform/variables.tf`
variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "feedback-app-eks"
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.31"
}

variable "node_instance_types" {
  description = "Instance types for EKS nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_group_min_size" {
  description = "Minimum number of EKS nodes"
  type        = number
  default     = 2
}

variable "node_group_max_size" {
  description = "Maximum number of EKS nodes"
  type        = number
  default     = 4
}

variable "node_group_desired_size" {
  description = "Desired number of EKS nodes"
  type        = number
  default     = 2
}
```

- Configure an ALB

## State Tracking

HCP workspace now stores state - no manual configuration of S3 bucket and DynamoDB lock required. Somewhat locking in to vendor for future stack implementation.

## Stage 2: Single Cluster EKS Infrastructure set-up

The author intended modularity to be a core design element for this lab and incrementally developed the application.

A branch was created to implement two EC2 instances on public networks, from there the following could be implemented:

- A VPC module, configurable via the `terraform/variables.tf` file which pass to the vpc module `terraform/modules/vpc/main.tf` as required.

- A security_groups module `terraform/modules/security_groups/main.tf` following same design as above.

- An EC2 module `terraform/modules/ec2/main.tf` which retrieves the latest AWS-Linux 2023 AMI and allows for configuration of instances via variables passed from the `terraform/variables.tf` file

Examples of variables configured as per the brief instructions in `terraform/variables.tf` include:

```hcl
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
```

## Stage 2: Conclusions
