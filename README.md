# 🔁 AWS ElastiCache Terraform module 🔁

* All usage examples are in the root `examples` folder. ***Keep in mind they show implementation with `Terragrunt`.***

* This module can provision `ElastiCache Replication group` with all the needed sub-resources (`Security group`, `Subnet group` & `Parameter group`).

* You can create the `Replication group` with `cluster mode` enabled / disabled. The `global_replication_group_id` parameter is also supported.

* As a very small core was used ***[module from Cloud Posse](https://github.com/cloudposse/terraform-aws-elasticache-redis)***, but the final code is fully refactored. I've decided to do it because the `Cloud Posse` version has some bugs, disadvantages, etc which haven't been fixed for a long time. Sincerely hope I've managed to fix all the mentioned troubles 😄

* I know this module can be not ideal, so I'm open to community contributions 🤗 Don't hesitate to create Issues or Pull requests!

# 🧱 Resources 🧱

| Name | Type |
|------|------|
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.this_ingress_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.this_ingress_cidr_blocks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.this_ingress_source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.this_egress_cidr_blocks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.this_egress_source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_elasticache_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_elasticache_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |

# 💠 Requirements 💠

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.30.0 |

# 🔘 Providers 🔘
| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.30.0 |
