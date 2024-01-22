# ---------------------------------------------------------------------------------------------------------------------
# Security Group
# ---------------------------------------------------------------------------------------------------------------------

variable "create_security_group" {
  type        = bool
  default     = false
  description = "Controls if Security Group should be created."
}

variable "security_group_name" {
  type        = string
  default     = null
  description = "Name of the Security Group. If omitted, Terraform will assign a random, unique name."
}

variable "security_group_description" {
  type        = string
  default     = "Managed by Terraform"
  description = "Security Group description."
}

variable "vpc_id" {
  type        = string
  default     = null
  description = "VPC ID."
}

variable "revoke_rules_on_delete" {
  type        = bool
  default     = false
  description = "Instruct Terraform to revoke all of the Security Groups attached ingress and egress rules before deleting the rule itself."
}

variable "security_group_tags" {
  type        = map(string)
  default     = null
  description = "A map of tags to assign to the resource."
}

# ---------------------------------------------------------------------------------------------------------------------
# Security Group Rules
# ---------------------------------------------------------------------------------------------------------------------

# Ingress block

variable "ingress_self" {
  type        = bool
  default     = false
  description = "Whether the Security Group itself will be added as a source to this ingress rule."
}

variable "ingress_self_rule_description" {
  type        = string
  default     = null
  description = "Description of the rule."
}

variable "ingress_from_port" {
  type        = number
  default     = null
  description = "End port."
}

variable "ingress_to_port" {
  type        = number
  default     = null
  description = "Start port."
}

variable "ingress_protocol" {
  type        = string
  default     = "tcp"
  description = "Protocol."
}

variable "ingress_cidr_blocks_rule_description" {
  type        = string
  default     = null
  description = "Description of the rule."
}

variable "ingress_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "List of CIDR blocks."
}

variable "ingress_ipv6_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "List of IPv6 CIDR blocks."
}

variable "ingress_source_rule_description" {
  type        = string
  default     = null
  description = "Description of the rule."
}

variable "ingress_source_security_group_ids" {
  type        = list(string)
  default     = []
  description = "Security group ids to allow access to/from, depending on the type."
}

# Egress block

variable "egress_cidr_blocks_rule_description" {
  type        = string
  default     = null
  description = "Description of the rule."
}

variable "egress_from_port" {
  type        = number
  default     = null
  description = "End port."
}

variable "egress_to_port" {
  type        = number
  default     = null
  description = "Start port."
}

variable "egress_protocol" {
  type        = string
  default     = "tcp"
  description = "Protocol."
}

variable "egress_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "List of CIDR blocks."
}

variable "egress_ipv6_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "List of IPv6 CIDR blocks."
}

variable "egress_source_rule_description" {
  type        = string
  default     = null
  description = "Description of the rule."
}

variable "egress_source_security_group_ids" {
  type        = list(string)
  default     = []
  description = "Security group ids to allow access to/from, depending on the type."
}

# ---------------------------------------------------------------------------------------------------------------------
# Subnet Group
# ---------------------------------------------------------------------------------------------------------------------

variable "create_subnet_group" {
  type        = bool
  default     = false
  description = "Controls if Subnet Group should be created."
}

variable "subnet_group_name" {
  type        = string
  default     = null
  description = "Name for the cache subnet group. ElastiCache converts this name to lowercase."
}

variable "subnet_group_description" {
  type        = string
  default     = null
  description = "Description for the cache subnet group. Defaults to `Managed by Terraform`."
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of VPC Subnet IDs for the cache subnet group."
  default     = []
}

variable "subnet_group_tags" {
  type        = map(string)
  default     = null
  description = "A map of tags to assign to the resource."
}

# ---------------------------------------------------------------------------------------------------------------------
# Parameter Group
# ---------------------------------------------------------------------------------------------------------------------

variable "create_parameter_group" {
  type        = bool
  default     = true
  description = "Whether new parameter group should be created. Set to false if you want to use existing parameter group."
}

variable "parameter_group_name" {
  type        = string
  default     = null
  description = "Name of the parameter group to associate with this replication group. If this argument is omitted, the default cache parameter group for the specified engine is used."
}

variable "parameter_group_description" {
  type        = string
  default     = "Managed by Terraform"
  description = "The description of the ElastiCache parameter group."
}

variable "family" {
  type        = string
  default     = "redis7"
  description = "The family of the ElastiCache parameter group."
}

variable "parameter" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "A list of Redis parameters to apply. Note that parameters may differ from one Redis family to another."
}

variable "parameter_group_tags" {
  type        = map(string)
  default     = null
  description = "A map of tags to assign to the resource."
}

# ---------------------------------------------------------------------------------------------------------------------
# Replication Group
# ---------------------------------------------------------------------------------------------------------------------

variable "create_replication_group" {
  type        = bool
  default     = true
  description = "Controls if Replication Group should be created."
}

variable "cluster_mode_enabled" {
  type        = bool
  default     = false
  description = "Flag to enable/disable creation of a native Redis cluster. `automatic_failover_enabled` must be set to `true`."
}

variable "auth_token" {
  type        = string
  description = "Password used to access a password protected server. Can be specified only if `transit_encryption_enabled = true`. Password must be longer than 16 chars."
  default     = null
}

variable "auth_token_update_strategy" {
  type        = string
  default     = "ROTATE"
  description = "Strategy to use when updating the auth_token. Valid values are `SET`, `ROTATE`, and `DELETE`."
}

variable "global_replication_group_id" {
  type        = string
  default     = null
  description = <<-EOT
    The ID of the global replication group to which this replication group should belong. 
    If this parameter is specified, the replication group is added to the specified global replication group as a secondary replication group; 
    otherwise, the replication group is not part of any global replication group.
  EOT
}

variable "replication_group_id" {
  type        = string
  default     = null
  description = "Replication group ID with the following constraints: \nA name must contain from 1 to 20 alphanumeric characters or hyphens. \n The first character must be a letter. \n A name cannot end with a hyphen or contain two consecutive hyphens."
}

variable "description" {
  type        = string
  default     = "Managed by Terraform"
  description = "User-created description for the replication group. Must not be empty."
}

variable "node_type" {
  type        = string
  default     = null
  description = "Instance class to be used."
}

variable "num_cache_clusters" {
  type        = number
  default     = 1
  description = "Number of cache clusters (primary and replicas) this replication group will have. If Multi-AZ is enabled, the value of this parameter must be at least 2."
}

variable "port" {
  type        = number
  default     = 6379
  description = "Port number on which each of the cache nodes will accept connections."
}

variable "preferred_cache_cluster_azs" {
  type        = list(string)
  default     = []
  description = <<-EOT
    List of EC2 availability zones in which the replication group's cache clusters will be created. 
    The order of the availability zones in the list is considered. 
    The first item in the list will be the primary node.
  EOT
}

variable "automatic_failover_enabled" {
  type        = bool
  default     = false
  description = <<EOT
    Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. 
    If enabled, `num_cache_clusters` must be greater than 1. 
    Must be enabled for Redis (cluster mode enabled) replication groups.
  EOT
}

variable "ip_discovery" {
  type        = string
  default     = null
  description = "The IP version to advertise in the discovery protocol. Valid values are `ipv4` or `ipv6`."
}

variable "network_type" {
  type        = string
  default     = null
  description = "The IP versions for cache cluster connections. Valid values are `ipv4`, `ipv6` or `dual_stack`."
}

variable "multi_az_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether to enable Multi-AZ Support for the replication group. If true, `automatic_failover_enabled` must also be enabled."
}

variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = <<EOT
    IDs of one or more Amazon VPC security groups associated with this replication group. 
    Use this parameter only when you are creating a replication group in an Amazon Virtual Private Cloud.
  EOT
}

variable "maintenance_window" {
  type        = string
  default     = "wed:03:00-wed:04:00"
  description = <<EOT
    Specifies the weekly time range for when maintenance on the cache cluster is performed.
    The format is `ddd:hh24:mi-ddd:hh24:mi` (24H Clock UTC).
    The minimum maintenance window is a 60 minute period. Example: `sun:05:00-sun:09:00`.
  EOT
}

variable "notification_topic_arn" {
  type        = string
  default     = null
  description = "ARN of an SNS topic to send ElastiCache notifications to."
}

variable "engine" {
  type        = string
  default     = "redis"
  description = "Name of the cache engine to be used for the clusters in this replication group. The only valid value is `redis`."
}

variable "engine_version" {
  type        = string
  default     = "7.1"
  description = "Version number of the cache engine to be used for the cache clusters in this replication group."
}

variable "at_rest_encryption_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable encryption at rest."
}

variable "kms_key_id" {
  type        = string
  default     = null
  description = "The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. `at_rest_encryption_enabled` must be set to `true`."
}

variable "transit_encryption_enabled" {
  type        = bool
  default     = false
  description = <<-EOT
    Whether to enable encryption in transit. Forced `true` if `var.auth_token` is set.
    If this is enabled, use the [following guide](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/in-transit-encryption.html#connect-tls) to access Redis.
  EOT
}

variable "snapshot_name" {
  type        = string
  description = "Name of a snapshot from which to restore data into the new node group. Changing the `snapshot_name` forces a new resource."
  default     = null
}

variable "snapshot_arns" {
  type        = list(string)
  default     = []
  description = "List of ARNs that identify Redis RDB snapshot files stored in Amazon S3. The names object names cannot contain any commas. Example: arn:aws:s3:::my_bucket/snapshot1.rdb"
}

variable "snapshot_window" {
  type        = string
  default     = null
  description = "Daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum snapshot window is a 60 minute period. Example: 05:00-09:00"
}

variable "snapshot_retention_limit" {
  type        = number
  default     = 0
  description = "Number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them."
}

variable "final_snapshot_identifier" {
  type        = string
  default     = null
  description = <<EOT
    The name of your final node group (shard) snapshot. 
    ElastiCache creates the snapshot from the primary node in the cluster. 
    If omitted, no final snapshot will be made."
  EOT
}

variable "apply_immediately" {
  type        = bool
  default     = false
  description = "Specifies whether any modifications are applied immediately, or during the next maintenance window."
}

variable "data_tiering_enabled" {
  type        = bool
  default     = false
  description = "Enables data tiering. Data tiering is only supported for replication groups using the r6gd node type."
}

variable "auto_minor_version_upgrade" {
  type        = bool
  default     = true
  description = <<EOT
    Specifies whether minor version engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window. 
    Only supported for engine type "redis" and if the engine version is 6 or higher. 
  EOT
}

variable "log_delivery_configuration" {
  type        = list(map(any))
  default     = []
  description = "The `log_delivery_configuration` block allows the streaming of Redis `SLOWLOG` or Redis `Engine Log` to CloudWatch Logs or Kinesis Data Firehose. Max of 2 blocks."
}

variable "num_node_groups" {
  type        = number
  default     = 0
  description = "Number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications."
}

variable "replicas_per_node_group" {
  type        = number
  default     = 0
  description = "Number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will force a new resource."
}

variable "user_group_ids" {
  type        = list(string)
  default     = null
  description = "User Group ID to associate with the replication group. Only a maximum of one (1) user group ID is valid."
}

variable "replication_group_tags" {
  type        = map(string)
  default     = null
  description = "A map of tags to assign to the resource."
}
