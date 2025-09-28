resource "aws_secretsmanager_secret" "secretManager" {
  name        = lower("${var.common_tags["env"]}/${var.common_tags["proj"]}/${var.sm_name}")
  kms_key_id = var.kms_id  
}