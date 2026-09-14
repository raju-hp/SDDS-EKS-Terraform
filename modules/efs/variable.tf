variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "allowed_sg_ids" {
  type = list(string)
}

variable "throughput_mode" {
  type    = string
  default = "elastic"
}

variable "tags" {
  type    = map(string)
  default = {}
}
