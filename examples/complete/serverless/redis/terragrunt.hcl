
terraform {
  source = "github.com/itsyndicate/terraform-aws-elasticache//."
}

dependency "vpc" {
  config_path = "../vpc"
}

locals {

  prefix = "my-redis-cache-serverless"
  tags   = local.environment_vars.locals.tags
}

inputs = {
  name                   = local.prefix
  engine                 = "redis"
  cache_type             = "serverless"
  create_security_group  = true
  security_group_name    = local.prefix
  revoke_rules_on_delete = true
  subnet_group_name      = local.prefix
  vpc_id                 = dependency.vpc.outputs.vpc_id
  subnet_ids             = dependency.vpc.outputs.private_subnets
  serverless_tags        = { Name = "${local.prefix}-cache" }

  # Serverless-specific inputs
  data_storage_maximum    = 3
  ecpu_per_second_maximum = 2000
}
