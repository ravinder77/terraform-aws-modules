
locals {
  port = var.engine == "postgres" ? 5432 : 3306

  inferred_family = {
    postgres = "postgres15"
    mysql    = "mysql8.0"
    mariadb  = "mariadb10.6"
  }[var.engine]

  family = coalesce(var.parameter_group_family, local.inferred_family)

  common_tags = merge(var.tags, {
    ManagedBy = "terraform"
    Module    = "rds"
  })
}
