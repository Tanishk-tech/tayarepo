resource "aws_lb" "lb" {
  name                       = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.lb_name}"
  internal                   = var.lb_internal
  load_balancer_type         = var.lb_type
  security_groups            = [aws_security_group.main.id]
  subnets                    = var.lb_subnets
  preserve_host_header       = var.host_preserve
  enable_deletion_protection = var.lb_del_protection

  dynamic "access_logs" {
    for_each = var.enable_access_logs ? [1] : []

    content {
      bucket  = var.lb_logs_bucket_id
      prefix  = var.lb_logs_prefix
      enabled = var.lb_logs_enabled
    }
  }
}