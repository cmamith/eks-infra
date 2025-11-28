variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "cluster_version" {
  type        = string
  description = "EKS version"
}

variable "vpc_id" {
  type        = string
  description = "VPC where EKS will be deployed"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnets for worker nodes"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnets for ALB ingress"
  default     = []
}

variable "node_group_name" {
  type        = string
  description = "Name of the EKS managed node group"
}

variable "node_instance_types" {
  type        = list(string)
  description = "EC2 instance types for the node group"
}

variable "node_desired_size" {
  type        = number
  description = "Desired number of nodes"
}

variable "node_min_size" {
  type        = number
  description = "Minimum number of nodes"
}

variable "node_max_size" {
  type        = number
  description = "Maximum number of nodes"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}
