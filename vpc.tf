
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  vpc_name           = var.vpc_name
  azs                = var.azs
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  enable_nat_gateway = var.enable_nat_gateway
  tags               = var.tags
}
