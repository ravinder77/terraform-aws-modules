output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.main.id
}

output "vpc_arn" {
  description = "VPC ARN."
  value       = aws_vpc.main.arn
}

output "vpc_cidr_block" {
  description = "VPC CIDR block."
  value       = aws_vpc.main.cidr_block
}

output "public_subnets" {
  description = "Public subnet IDs."
  value       = values(aws_subnet.public_subnet)[*].id
}

output "private_subnets" {
  description = "Private subnet IDs."
  value       = values(aws_subnet.private_subnet)[*].id
}

output "nat_gateway_id" {
  description = "NAT gateway IDs."
  value       = values(aws_nat_gateway.nat)[*].id
}

output "public_route_table_id" {
  description = "Public route table ID."
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "Private route table IDs."
  value       = values(aws_route_table.private)[*].id
}

output "internet_gateway_id" {
  description = "Internet gateway ID."
  value       = try(aws_internet_gateway.igw[0].id, null)
}

output "flow_log_id" {
  description = "VPC flow log ID when enabled."
  value       = try(aws_flow_log.vpc[0].id, null)
}

output "aws_account_id" {
  description = "AWS account ID."
  value       = data.aws_caller_identity.current.account_id
}
