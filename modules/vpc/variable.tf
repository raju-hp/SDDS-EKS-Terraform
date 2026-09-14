variable "name" {
  type = string
}

variable "environment" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)

  validation {
    condition     = length(var.availability_zones) >= length(var.public_subnets) && length(var.availability_zones) >= length(var.private_subnets)
    error_message = "availability_zones must contain at least as many AZs as the public/private subnet lists."
  }
}
