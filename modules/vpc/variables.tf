variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "public_subnets" {
  type = list(string)
  validation {
    condition     = length(var.public_subnets) > 0 && alltrue([for subnet in var.public_subnets : can(cidrhost(subnet, 0))])
    error_message = "public_subnets must contain at least one valid IPv4 CIDR block."
  }
}

variable "private_subnets" {
  type = list(string)
  validation {
    condition     = length(var.private_subnets) > 0 && alltrue([for subnet in var.private_subnets : can(cidrhost(subnet, 0))])
    error_message = "private_subnets must contain at least one valid IPv4 CIDR block."
  }
}

variable "azs" {
  type = list(string)
  validation {
    condition     = length(var.azs) == length(var.public_subnets) && length(var.azs) == length(var.private_subnets)
    error_message = "azs, public_subnets, and private_subnets must have the same number of elements."
  }
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
