# ---------------------------------------------------------------------------------------------------------------------
# Security Group
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "this" {
  count = var.create_security_group ? 1 : 0

  name                   = var.security_group_name
  description            = var.security_group_description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

  tags = var.security_group_tags

  lifecycle {
    create_before_destroy = true
  }

}

# ---------------------------------------------------------------------------------------------------------------------
# Security Group Rules
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group_rule" "this_ingress_self" {
  count = var.ingress_self ? 1 : 0

  description       = var.ingress_self_rule_description
  type              = "ingress"
  from_port         = var.ingress_from_port
  to_port           = var.ingress_to_port
  protocol          = var.ingress_protocol
  self              = true
  security_group_id = aws_security_group.this[0].id
}


resource "aws_security_group_rule" "this_ingress_cidr_blocks" {
  count = var.create_security_group && length(var.ingress_cidr_blocks) > 0 || var.create_security_group && length(var.ingress_ipv6_cidr_blocks) > 0 ? try(length(var.ingress_cidr_blocks), length(var.ingress_ipv6_cidr_blocks)) : 0

  description       = try(try(element(var.ingress_cidr_blocks_rule_descriptions, count.index), var.ingress_cidr_blocks_rule_descriptions[0]), null)
  type              = "ingress"
  from_port         = var.ingress_from_port
  to_port           = var.ingress_to_port
  protocol          = var.ingress_protocol
  cidr_blocks       = try([element(var.ingress_cidr_blocks, count.index)], [])
  ipv6_cidr_blocks  = try([element(var.ingress_ipv6_cidr_blocks, count.index)], [])
  security_group_id = aws_security_group.this[0].id
}

resource "aws_security_group_rule" "this_ingress_source" {
  count = var.create_security_group && length(var.ingress_source_security_group_ids) > 0 ? length(var.ingress_source_security_group_ids) : 0

  description              = try(element(var.ingress_source_rule_descriptions, count.index), null)
  type                     = "ingress"
  from_port                = var.ingress_from_port
  to_port                  = var.ingress_to_port
  protocol                 = var.ingress_protocol
  source_security_group_id = element(var.ingress_source_security_group_ids, count.index)
  security_group_id        = aws_security_group.this[0].id
}

resource "aws_security_group_rule" "this_egress_cidr_blocks" {
  count = var.create_security_group && length(var.egress_cidr_blocks) > 0 || var.create_security_group && length(var.egress_ipv6_cidr_blocks) > 0 ? try(length(var.egress_cidr_blocks), length(var.egress_ipv6_cidr_blocks)) : 0

  description       = try(try(element(var.egress_cidr_blocks_rule_descriptions, count.index), var.egress_cidr_blocks_rule_descriptions[0]), null)
  type              = "egress"
  from_port         = var.egress_from_port
  to_port           = var.egress_to_port
  protocol          = var.egress_protocol
  cidr_blocks       = try([element(var.egress_cidr_blocks, count.index)], [])
  ipv6_cidr_blocks  = try([element(var.egress_ipv6_cidr_blocks, count.index)], [])
  security_group_id = aws_security_group.this[0].id
}

resource "aws_security_group_rule" "this_egress_source" {
  count = var.create_security_group && length(var.egress_source_security_group_ids) > 0 ? length(var.egress_source_security_group_ids) : 0

  description              = try(element(var.egress_source_rule_descriptions, count.index), null)
  type                     = "egress"
  from_port                = var.egress_from_port
  to_port                  = var.egress_to_port
  protocol                 = var.egress_protocol
  source_security_group_id = element(var.egress_source_security_group_ids, count.index)
  security_group_id        = aws_security_group.this[0].id
}

# ---------------------------------------------------------------------------------------------------------------------
# Subnet Group
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_elasticache_subnet_group" "this" {
  count = var.cache_type == "traditional" && var.create_subnet_group ? 1 : 0

  name        = var.subnet_group_name
  description = var.subnet_group_description
  subnet_ids  = var.subnet_ids
  tags        = var.subnet_group_tags
}

# ---------------------------------------------------------------------------------------------------------------------
# Parameter Group
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_elasticache_parameter_group" "this" {
  count = var.create_parameter_group ? 1 : 0

  name        = var.parameter_group_name
  description = var.parameter_group_description
  family      = var.family

  dynamic "parameter" {
    for_each = var.cluster_mode_enabled ? concat([
      { name = "cluster-enabled", value = "yes" }
    ], var.parameter) : var.parameter
    content {
      name  = parameter.value.name
      value = tostring(parameter.value.value)
    }
  }

  tags = var.parameter_group_tags

  lifecycle {
    create_before_destroy = true

    # Ignore changes to the description since it will try to recreate the resource
    ignore_changes = [
      description,
    ]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Replication Group
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_elasticache_replication_group" "this" {
  count = var.create_replication_group ? 1 : 0

  auth_token                  = var.transit_encryption_enabled ? var.auth_token : null
  auth_token_update_strategy  = var.auth_token_update_strategy
  global_replication_group_id = var.global_replication_group_id
  replication_group_id        = var.replication_group_id
  description                 = var.description
  node_type                   = var.global_replication_group_id == null ? var.node_type : null
  num_cache_clusters          = var.cluster_mode_enabled ? null : var.num_cache_clusters
  port                        = var.port
  parameter_group_name        = var.global_replication_group_id == null && var.create_parameter_group ? aws_elasticache_parameter_group.this[0].id : (var.global_replication_group_id == null && !var.create_parameter_group ? var.parameter_group_name : null)
  preferred_cache_cluster_azs = length(var.preferred_cache_cluster_azs) == 0 ? null : [
    for n in range(0, var.num_cache_clusters) : element(var.preferred_cache_cluster_azs, n)
  ]
  automatic_failover_enabled = var.cluster_mode_enabled ? true : var.automatic_failover_enabled
  ip_discovery               = var.ip_discovery
  network_type               = var.network_type
  multi_az_enabled           = var.multi_az_enabled
  subnet_group_name          = var.create_subnet_group ? aws_elasticache_subnet_group.this[0].name : var.subnet_group_name
  security_group_ids         = var.create_security_group ? [aws_security_group.this[0].id] : var.security_group_ids
  maintenance_window         = var.maintenance_window
  notification_topic_arn     = var.notification_topic_arn
  engine                     = var.global_replication_group_id == null ? var.engine : null
  engine_version             = var.global_replication_group_id == null ? var.engine_version : null
  at_rest_encryption_enabled = var.global_replication_group_id == null ? var.at_rest_encryption_enabled : null
  kms_key_id                 = var.at_rest_encryption_enabled ? var.kms_key_id : null
  transit_encryption_enabled = var.auth_token != null && var.global_replication_group_id == null ? var.transit_encryption_enabled : null
  snapshot_name              = var.global_replication_group_id == null ? var.snapshot_name : null
  snapshot_arns              = var.global_replication_group_id == null ? var.snapshot_arns : null
  snapshot_window            = var.snapshot_window
  snapshot_retention_limit   = var.snapshot_retention_limit
  final_snapshot_identifier  = var.final_snapshot_identifier
  apply_immediately          = var.apply_immediately
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  data_tiering_enabled       = var.data_tiering_enabled

  dynamic "log_delivery_configuration" {
    for_each = var.log_delivery_configuration

    content {
      destination      = lookup(log_delivery_configuration.value, "destination", null)
      destination_type = lookup(log_delivery_configuration.value, "destination_type", null)
      log_format       = lookup(log_delivery_configuration.value, "log_format", null)
      log_type         = lookup(log_delivery_configuration.value, "log_type", null)
    }
  }

  num_node_groups         = var.cluster_mode_enabled && var.global_replication_group_id == null ? var.num_node_groups : null
  replicas_per_node_group = var.cluster_mode_enabled ? var.replicas_per_node_group : null
  user_group_ids          = var.user_group_ids

  tags = var.replication_group_tags

  # When importing an aws_elasticache_replication_group resource the attribute
  # security_group_names is imported as null. More details:
  # https://github.com/hashicorp/terraform-provider-aws/issues/32835
  lifecycle {
    ignore_changes = [
      security_group_names,
    ]
  }

  depends_on = [
    aws_elasticache_parameter_group.this,
    aws_elasticache_subnet_group.this,
    aws_security_group.this
  ]
}

resource "aws_elasticache_serverless_cache" "serverless" {
  count = var.cache_type == "serverless" ? 1 : 0

  engine             = var.engine
  name               = var.name
  security_group_ids = var.create_security_group ? [aws_security_group.this[0].id] : var.security_group_ids
  subnet_ids         = var.subnet_ids

  cache_usage_limits {
    data_storage {
      maximum = var.data_storage_maximum
      unit    = "GB"
    }
    ecpu_per_second {
      maximum = var.ecpu_per_second_maximum
    }
  }

  tags = var.serverless_tags

  depends_on = [
    aws_security_group.this
  ]
}
