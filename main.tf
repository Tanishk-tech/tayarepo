locals {
  baseDomainName = "tayaenterprise.shop"
  certARN        = ""

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

# module "aeKms" {
#   source      = "github.com/Tanishk-tech/tayarepo//kms?ref=childModules"
#   common_tags = var.common_tags
# }

module "vpc" {
  source               = "github.com/Tanishk-tech/tayarepo//VPC?ref=childModules"
  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  common_tags          = var.common_tags
}

module "subnets" {
  source                      = "github.com/Tanishk-tech/tayarepo//Subnet?ref=childModules"
  vpc_id                      = module.vpc.vpc_id
  igw_id                      = module.vpc.internet_gateway_id
  dynamic_subnet_types        = var.dynamic_subnet_types
  azs                         = var.azs
  subnets                     = var.subnets
  create_dynamic_subnets      = var.create_dynamic_subnets
  common_tags                 = var.common_tags
  use_nat                     = true
  use_individual_nat_gateways = var.use_individual_nat_gateways
}

module "s3-code-deploy" {
  source            = "github.com/Tanishk-tech/tayarepo//S3?ref=childModules"
  s3_name           = "code-deploy"
  s3_acl            = var.s3_acl
  s3_versioning     = "Disabled"
  s3_index_document = var.s3_index_document
  s3_error_document = var.s3_error_document
  s3_enable_website = false
  s3_routing_rules  = var.s3_routing_rules
  common_tags       = var.common_tags
}


module "s3-config" {
  source            = "github.com/Tanishk-tech/tayarepo//S3?ref=childModules"
  s3_name           = "apps-config"
  s3_acl            = var.s3_acl
  s3_versioning     = "Disabled"
  s3_index_document = var.s3_index_document
  s3_error_document = var.s3_error_document
  s3_enable_website = false
  s3_routing_rules  = var.s3_routing_rules
  common_tags       = var.common_tags
  folders           = ["configs", "configs"]
}

module "s3-logs" {
  source            = "github.com/Tanishk-tech/tayarepo//S3?ref=childModules"
  s3_name           = "apps-logs"
  s3_acl            = var.s3_acl
  s3_versioning     = "Disabled"
  s3_index_document = var.s3_index_document
  s3_error_document = var.s3_error_document
  s3_enable_website = false
  s3_routing_rules  = var.s3_routing_rules
  common_tags       = var.common_tags
}

module "mtls-truststore" {
  source            = "github.com/Tanishk-tech/tayarepo//S3?ref=childModules"
  s3_name           = "mtls-truststore"
  s3_acl            = var.s3_acl
  s3_versioning     = var.s3_versioning
  s3_index_document = var.s3_index_document
  s3_error_document = var.s3_error_document
  s3_enable_website = false
  s3_routing_rules  = var.s3_routing_rules
  common_tags       = var.common_tags
}

module "s3_heapdump" {
  source            = "github.com/Tanishk-tech/tayarepo//S3?ref=childModules"
  s3_name           = "heapdump"
  s3_acl            = var.s3_acl
  s3_versioning     = "Suspended"
  s3_index_document = var.s3_index_document
  s3_error_document = var.s3_error_document
  s3_enable_website = false
  s3_routing_rules  = var.s3_routing_rules
  common_tags       = var.common_tags
}

module "ec2_instance" {
  source        = "github.com/Tanishk-tech/tayarepo//EC2?ref=childModules"
  ami           = var.ec2_ui_ami
  instance_type = var.ec2_ui_inst_type
  subnet_id     = module.subnets.public_subnet_ids[0]
  key_name      = var.key_name
  instance_name = var.ui_instance_name
  common_tags   = var.common_tags
}


# module "Route53" {
#   source           = "github.com/Tanishk-tech/tayarepo//Route53?ref=childModules"
#   zone_domain_name = local.baseDomainName
#   only_recods      = true
#   manual_zone_id   = ""
#   records = {
#     dev_lb = {
#       sub_domain = "dev"
#       type       = "CNAME"
#       ttl        = 30
#       records    = [module.albv2.lb_dns_name]
#     },
#   }
# }

# module "ec2-keypair" {
#   source      = "github.com/Tanishk-tech/tayarepo//ec2-pair?ref=childModules"
#   common_tags = var.common_tags
#   public_key  = var.ec2_pub_keys
# }


# module "ui_tg" {
#   source                           = "github.com/Tanishk-tech/tayarepo//ALB_TG?ref=childModules"
#   target_group_name                = "ui-tg"
#   port                             = 80
#   protocol                         = "HTTP"
#   vpc_id                           = module.vpc.vpc_id
#   health_check_healthy_threshold   = 3
#   health_check_unhealthy_threshold = 2
#   health_check_timeout             = 5
#   health_check_interval            = 30
#   health_check_path                = "/"
#   health_check_port                = "80"
#   health_check_protocol            = "HTTP"
#   health_check_matcher             = "200"
#   common_tags                      = var.common_tags
#   deregistration_delay             = 60
# }



# module "api_tg" {
#   source                           = "github.com/Tanishk-tech/tayarepo//ALB_TG?ref=childModules"
#   target_group_name                = "api-tg"
#   port                             = 9000
#   protocol                         = "HTTP"
#   vpc_id                           = module.vpc.vpc_id
#   health_check_healthy_threshold   = 3
#   health_check_unhealthy_threshold = 2
#   health_check_timeout             = 5
#   health_check_interval            = 30
#   health_check_path                = "/"
#   health_check_port                = "9000"
#   health_check_protocol            = "HTTP"
#   health_check_matcher             = "401"
#   common_tags                      = var.common_tags
#   stickiness                       = false
#   deregistration_delay             = 60
# }

# module "asg_ui" {
#   source           = "github.com/Tanishk-tech/tayarepo//ASG?ref=childModules"
#   asg_name         = "ui-asg"
#   desired_capacity = 1
#   min_size         = 1
#   max_size         = 4
#   ami              = var.ec2_ui_ami
#   vpc_id           = module.vpc.vpc_id
#   vpc_subnets      = module.subnets.private_subnet_ids
#   instance_type    = var.ec2_ui_inst_type
#   key_name         = module.ec2-keypair.ec2_key_name
#   user_data        = ""
#   # kms_id           = module.ae_kms.kms_arn
#   common_tags      = var.common_tags
#   buckets_readonly = [module.s3-code-deploy.s3_id, module.s3-config.s3_id]
#   # buckets_write    = [module.s3-logs.s3_id]
#   alerts_enabled   = true

#   cpu_evaluation_periods = 1
#   cpu_threshold_max      = 80
#   cpu_threshold_min      = 40
#   cpu_period             = 300
#   cpu_statistic          = "Maximum"
#   auto_scale_on_cpu      = true

#   ram_evaluation_periods = 1
#   ram_threshold_max      = 80
#   ram_threshold_min      = 40
#   ram_period             = 300
#   ram_statistic          = "Maximum"
#   auto_scale_on_ram      = true

#   disk_evaluation_periods = 1
#   disk_threshold          = 80
#   disk_period             = 300
#   disk_statistic          = "Average"
#   root_volume_size        = 50

#   ssm_ssh                = true
#   isCouldWatchAgentPerm  = true
#   isCouldWatchLogs       = true
#   asg_termination_policy = ["OldestInstance"]
#   # block_device_mappings = [
#   #   {
#   #     device_name = "/dev/sda1"
#   #     device_size = 80
#   #   }
#   # ]
#   tg_arn = [module.ui_tg.target_group_arn]

#   ingress_rules = [
#     {
#       description     = "LB UI Access"
#       from_port       = 80
#       to_port         = 80
#       protocol        = "tcp"
#       cidr_blocks     = ["172.16.0.0/16"]
#       security_groups = []
#     },
#     {
#       description     = "Bastion SSH Access"
#       from_port       = 22
#       to_port         = 22
#       protocol        = "tcp"
#       cidr_blocks     = ["172.16.0.0/16"]
#       security_groups = []
#     }

#   ]
#   sg_outbond = ["0.0.0.0/0"]
# }


# module "albv2" {
#   source             = "github.com/Tanishk-tech/tayarepo//ALB?ref=childModules"
#   lb_name            = "alb"
#   lb_internal        = false
#   lb_type            = "application"
#   lb_subnets         = module.subnets.public_subnet_ids
#   cert_arn           = local.certificateArn
#   ssl_policy         = "ELBSecurityPolicy-TLS13-1-2-Res-FIPS-2023-04"
#   host_preserve      = true
#   lb_del_protection  = true
#   enable_access_logs = false
#   lb_logs_bucket_id  = "your-s3-bucket-id"
#   lb_logs_prefix     = "alb-logs"
#   lb_logs_enabled    = false
#   common_tags        = var.common_tags
#   vpc_id             = module.vpc.vpc_id
#   enable_mtls        = false

#   ca_certificates_bundle_s3_bucket         = module.mtls-truststore.s3_id
#   ca_certificates_bundle_s3_key            = "uat.crt"
#   ca_certificates_bundle_s3_object_version = ""
#   listener_rules = [
#     {
#       path_pattern     = "/*"
#       host_header      = "dev.${var.main_domain_name}"
#       priority         = 1
#       target_group_arn = module.ui_tg.target_group_arn
#     }
#   ]

#   ingress_rules = [
#     {
#       description = "Pub HTTP Access"
#       from_port   = 80
#       to_port     = 80
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     },
#     {
#       description = "Pub HTTPS Access"
#       from_port   = 443
#       to_port     = 443
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   ]
#   sg_outbond = ["0.0.0.0/0"]

# }

# module "secret_manager" {
#   source      = "github.com/Tanishk-tech/tayarepo//secretManager?ref=childModules"
#   sm_name     = var.secretManagerName
#   common_tags = var.common_tags
#   kms_id      = module.ae_kms.kms_arn
# }
