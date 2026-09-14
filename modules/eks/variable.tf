variable "github_actions_role_arn" {
  type    = string
  default = null
}

variable "name" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "node_instance_types" {
  type = list(string)
}

variable "node_min_size" {
  type = number
}

variable "node_desired_size" {
  type = number
}

variable "node_max_size" {
  type = number
}

variable "cluster_log_types" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}

# Leave these null to let the EKS API select the compatible addon version.
variable "pod_identity_addon_version" {
  type    = string
  default = null
}

variable "vpc_cni_addon_version" {
  type    = string
  default = null
}

variable "kube_proxy_addon_version" {
  type    = string
  default = null
}

variable "coredns_addon_version" {
  type    = string
  default = null
}

variable "efs_csi_addon_version" {
  type    = string
  default = null
}

variable "cloudwatch_addon_version" {
  type    = string
  default = null
}
