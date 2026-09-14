variable "region" {
  description = "AWS region."
  type        = string
}

variable "project_name" {
  description = "Project name used in resource names."
  type        = string
  default     = "sdds"
}

variable "name" {
  description = "Environment/VPC name."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "cidr_block" {
  description = "VPC CIDR."
  type        = string
}

variable "public_subnets" {
  description = "Public subnet CIDRs."
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet CIDRs."
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones. Must align with subnet lists."
  type        = list(string)
}

variable "tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}

variable "github_actions_role_arn" {
  description = "IAM role ARN used by GitHub Actions. This role is granted EKS admin access for kubectl deployments."
  type        = string
  default     = null
}

variable "eks_kubernetes_version" {
  description = "EKS Kubernetes version."
  type        = string
  default     = "1.36"
}

variable "eks_node_instance_types" {
  description = "Managed node group instance types."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "eks_node_min_size" {
  type    = number
  default = 2
}

variable "eks_node_desired_size" {
  type    = number
  default = 2
}

variable "eks_node_max_size" {
  type    = number
  default = 4
}

variable "sdds_image_tag" {
  description = "Initial SDDS image tag. Used by Kubernetes example manifests."
  type        = string
  default     = "latest"
}

variable "sdds_secret_name" {
  description = "Secrets Manager secret name."
  type        = string
  default     = "sdds/dev/application"
}

variable "sdds_username" {
  description = "SDDS application username."
  type        = string
  default     = "sdds"
}

variable "sdds_password" {
  description = "SDDS application password. This value will be stored in Terraform state; protect the state."
  type        = string
  sensitive   = true
  default     = null
}

variable "efs_throughput_mode" {
  type    = string
  default = "elastic"
}

variable "log_retention_days" {
  type    = number
  default = 30
}
