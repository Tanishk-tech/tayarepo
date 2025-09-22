locals {
  mainDomain = "taya.enterprise.com"
  certARN = ""

#   validate_dbPassword = (
#     var.dbPassword != "" ?
#     var.dbPassword :
#     error("❌ dbPassword is not set. Use TF_VAR_dbPassword to provide it.")
#   )

#   validate_mqPassword = (
#     var.mqPassword != "" ?
#     var.mqPassword :
#     error("❌ mqPassword is not set. Use TF_VAR_mqPassword to provide it.")
#   )

#   validate_redisPassword = (
#     var.redisPassword != "" ?
#     var.redisPassword :
#     error("❌ redisPassword is not set. Use TF_VAR_redisPassword to provide it.")
#   )
}

module "aeKms" {
  source      = "github.com/AlertEnterprise-Inc/aehsc-config//modules/kms?ref=tf-v1.0.0.1"
  common_tags = var.common_tags
}

module "vpc" {
  source               = "github.com/AlertEnterprise-Inc/aehsc-config//modules/vpc?ref=v1.0.2"
  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  common_tags          = var.common_tags
}

