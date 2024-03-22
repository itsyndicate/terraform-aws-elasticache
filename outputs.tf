# ---------------------------------------------------------------------------------------------------------------------
# Security Group
# ---------------------------------------------------------------------------------------------------------------------

output "security_group_arn" {
  value       = try(aws_security_group.this[0].arn, "")
  description = "ARN of the Security Group."
}

output "security_group_id" {
  value       = try(aws_security_group.this[0].id, "")
  description = "ID of the Security Group."
}

# ---------------------------------------------------------------------------------------------------------------------
# Subnet Group
# ---------------------------------------------------------------------------------------------------------------------

output "subnet_group_id" {
  value       = try(aws_elasticache_subnet_group.this[0].id, "")
  description = "ID of the Subnet Group."
}

output "subnet_group_subnet_ids" {
  value       = try(aws_elasticache_subnet_group.this[0].subnet_ids, "")
  description = "ID of the Subnet Group."
}

# ---------------------------------------------------------------------------------------------------------------------
# Parameter Group
# ---------------------------------------------------------------------------------------------------------------------

output "parameter_group_arn" {
  value       = try(aws_elasticache_parameter_group.this[0].arn, "")
  description = "ARN of the Parameter Group."
}

output "parameter_group_id" {
  value       = try(aws_elasticache_parameter_group.this[0].id, "")
  description = "ID of the Parameter Group."
}

# ---------------------------------------------------------------------------------------------------------------------
# Replication Group
# ---------------------------------------------------------------------------------------------------------------------

output "replication_group_arn" {
  value       = try(aws_elasticache_replication_group.this[0].arn, "")
  description = "ARN of the Replication Group."
}

output "replication_group_id" {
  value       = try(aws_elasticache_replication_group.this[0].id, "")
  description = "ID of the Replication Group."
}

output "replication_group_cluster_mode_enabled" {
  value       = try(aws_elasticache_replication_group.this[0].cluster_enabled, "")
  description = "Indicates if cluster mode is enabled."
}

output "replication_group_endpoint_address" {
  value       = length(aws_elasticache_replication_group.this) > 0 ? (var.cluster_mode_enabled ? aws_elasticache_replication_group.this[0].configuration_endpoint_address : aws_elasticache_replication_group.this[0].primary_endpoint_address) : ""
  description = "Address of the replication group endpoint."
}

output "replication_group_reader_endpoint_address" {
  value       = length(aws_elasticache_replication_group.this) > 0 ? (var.cluster_mode_enabled ? "" : aws_elasticache_replication_group.this[0].reader_endpoint_address) : ""
  description = "Address of the endpoint for the reader node in the replication group."
}
# ---------------------------------------------------------------------------------------------------------------------
# ElastiCache Endpoint Serverless
# ---------------------------------------------------------------------------------------------------------------------

output "serverless_cache_endpoint" {
  value       = var.cache_type == "serverless" ? aws_elasticache_serverless_cache.serverless[0].endpoint : null
  description = "The endpoint of the ElastiCache Serverless cache."
}
