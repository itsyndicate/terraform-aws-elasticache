# terragrunt.hcl for Memcached
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/itsyndicate/terraform-aws-elasticache//." # Ensure your module supports traditional deployments too
}

dependency "vpc" {
  config_path = "../vpc"
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  prefix = "my-redis-cache-memcache"

  tags   = local.environment_vars.locals.tags
}

inputs = {
  name                   = local.prefix
  engine                 = "memcached"
  cache_type             = "traditional"
  security_group_name    = local.prefix
  revoke_rules_on_delete = true
  create_subnet_group    = true
  subnet_group_name      = local.prefix
  vpc_id                 = dependency.vpc.outputs.vpc_id
  create_security_group  = false
  security_group_ids     = ["sg-0f1b450e3e3637286"]
  tags                   = { Name = "${local.prefix}-cache" }

  num_cache_clusters     = 3
  node_type              = "cache.t3.micro"
}
