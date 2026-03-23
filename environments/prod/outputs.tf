output "vpc_id" {
  description = "VPC ID for the environment."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = module.vpc.private_subnets
}

output "rds_instance_id" {
  description = "Primary RDS instance ID when enabled."
  value       = try(module.rds[0].db_instance_id, null)
}

output "rds_secret_arn" {
  description = "Secrets Manager ARN for the RDS master secret when enabled."
  value       = try(module.rds[0].secret_arn, null)
}
