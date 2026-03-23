variable "vpc_name" {
  description = "Name prefix for the VPC and related resources."
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC."
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks."
  type        = list(string)

  validation {
    condition     = length(var.public_subnets) > 0 && alltrue([for subnet in var.public_subnets : can(cidrhost(subnet, 0))])
    error_message = "public_subnets must contain at least one valid IPv4 CIDR block."
  }
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks."
  type        = list(string)

  validation {
    condition     = length(var.private_subnets) > 0 && alltrue([for subnet in var.private_subnets : can(cidrhost(subnet, 0))])
    error_message = "private_subnets must contain at least one valid IPv4 CIDR block."
  }
}

variable "azs" {
  description = "Availability zones aligned to the subnet lists."
  type        = list(string)

  validation {
    condition     = length(var.azs) == length(var.public_subnets) && length(var.azs) == length(var.private_subnets)
    error_message = "azs, public_subnets, and private_subnets must have the same number of elements."
  }

  validation {
    condition     = length(distinct(var.azs)) == length(var.azs)
    error_message = "azs must not contain duplicates."
  }
}

variable "enable_nat_gateway" {
  description = "Backwards-compatible switch for NAT creation. If false, no NAT gateways are created."
  type        = bool
  default     = true
}

variable "nat_gateway_mode" {
  description = "NAT gateway topology. Valid values are none, single, or one_per_az. If null, it is derived from enable_nat_gateway."
  type        = string
  default     = null

  validation {
    condition     = var.nat_gateway_mode == null || contains(["none", "single", "one_per_az"], var.nat_gateway_mode)
    error_message = "nat_gateway_mode must be one of: none, single, one_per_az."
  }
}

variable "enable_dns_support" {
  description = "Whether to enable DNS resolution in the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Whether to enable DNS hostnames in the VPC."
  type        = bool
  default     = true
}

variable "enable_vpc_flow_logs" {
  description = "Whether to enable VPC flow logs to CloudWatch Logs."
  type        = bool
  default     = false
}

variable "flow_log_retention_in_days" {
  description = "Retention period in days for flow log CloudWatch log groups."
  type        = number
  default     = 30
}

variable "flow_log_traffic_type" {
  description = "Traffic type captured by flow logs."
  type        = string
  default     = "ALL"

  validation {
    condition     = contains(["ACCEPT", "REJECT", "ALL"], var.flow_log_traffic_type)
    error_message = "flow_log_traffic_type must be one of: ACCEPT, REJECT, ALL."
  }
}

variable "public_subnet_tags" {
  description = "Additional tags applied only to public subnets."
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Additional tags applied only to private subnets."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}
