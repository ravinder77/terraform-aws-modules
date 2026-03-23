locals {
  effective_nat_gateway_mode = var.enable_nat_gateway ? coalesce(var.nat_gateway_mode, "single") : "none"

  public_subnet_map = {
    for index, az in var.azs : az => {
      cidr = var.public_subnets[index]
      name = "${var.vpc_name}-public-${az}"
    }
  }

  private_subnet_map = {
    for index, az in var.azs : az => {
      cidr = var.private_subnets[index]
      name = "${var.vpc_name}-private-${az}"
    }
  }

  nat_gateway_azs = local.effective_nat_gateway_mode == "one_per_az" ? var.azs : (
    local.effective_nat_gateway_mode == "single" ? [var.azs[0]] : []
  )

  private_route_table_azs = local.effective_nat_gateway_mode == "one_per_az" ? var.azs : ["shared"]
}
