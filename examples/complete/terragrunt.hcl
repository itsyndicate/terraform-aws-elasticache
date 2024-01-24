# ---------------------------------------------------------------------------------------------------------------------
# This is an example of how to create complete configuration using Terragrunt
# ---------------------------------------------------------------------------------------------------------------------
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/itsyndicate/terraform-aws-elasticache//."
}

# `dependency` block isn't mandatory; you can set `vpc & subnet ids` manually
dependency "vpc" {
  config_path = "../vpc"
}

inputs = {

  # Security Group
  create_security_group      = true
  security_group_name        = "my-redis-cache"
  security_group_description = "Security group of the {my-redis-cache} Redis cache"
  vpc_id                     = "${dependency.vpc.outputs.vpc_id}"
  security_group_tags        = {
    Name = "my-redis-cache"
  }

  # Security Group Ingress Rules
  ingress_self                  = true
  ingress_self_rule_description = "Access to Redis cache form itself"
  ingress_from_port             = 6379
  ingress_to_port               = 6379
  ingress_protocol              = "tcp"

  ingress_cidr_blocks_rule_descriptions = ["Allow access from staging VPC", "Allow access from production VPC"]
  ingress_cidr_blocks                   = ["1.2.3.4/16", "5.6.7.8/16"]

  # Security Group Egress Rules
  egress_cidr_blocks_rule_descriptions = ["Allow all outbound traffic"]
  egress_from_port                    = 0
  egress_to_port                      = 0
  egress_protocol                     = "-1"
  egress_cidr_blocks                  = ["0.0.0.0/0"]

  # Subnet Group
  create_subnet_group      = true
  subnet_group_name        = "my-redis-cache"
  subnet_group_description = "Subnet group of the {my-redis-cache} Redis cache"
  subnet_ids               = ["${dependency.vpc.outputs.subnet_a}", "${dependency.vpc.outputs.subnet_b}"]
  subnet_group_tags        = {
    Name = "my-redis-cache"
  }

  # Parameter Group
  create_parameter_group       = true
  parameter_group_name         = "my-redis-cache"
  parameter_group_description  = "Parameter group of the {my-redis-cache} Redis cache"
  family                       = "redis7"
  parameter_group_tags         = {
    Name = "my-redis-cache"
  }

  # Replication Group
  cluster_mode_enabled       = false
  replication_group_id       = "my-redis-cache"
  description                = "{my-redis-cache} Redis cache"
  node_type                  = "cache.t3.small"
  num_cache_clusters         = 1
  port                       = 6379
  automatic_failover_enabled = false
  ip_discovery               = "ipv4"
  network_type               = "ipv4"
  multi_az_enabled           = false
  maintenance_window         = "wed:08:00-wed:09:00"
  engine                     = "redis"
  engine_version             = "7.1"
  at_rest_encryption_enabled = true
  transit_encryption_enabled = false
  snapshot_name              = "snapshot-name"
  snapshot_window            = "05:00-06:00"
  snapshot_retention_limit   = 2
  final_snapshot_identifier  = "my-redis-cache-final-snapshot"
  apply_immediately          = true
  auto_minor_version_upgrade = true
  data_tiering_enabled       = false
  replication_group_tags     = {
    Name = "my-redis-cache"
  }
}
