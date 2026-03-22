variable "vpc_name" {
  description = "Name tag for the VPC."
  type        = string
  default     = "platform-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones used by the VPC."
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "enable_nat_gateway" {
  description = "Whether to create a NAT gateway for private subnet egress."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags applied to resources."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Project   = "terraform-aws-modules"
  }
}
