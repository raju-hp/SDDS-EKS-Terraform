variable "secret_name" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type      = string
  sensitive = true
  default   = null
}

variable "cluster_name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "service_account" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
