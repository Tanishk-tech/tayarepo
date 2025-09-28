resource "aws_lb_target_group" "this" {
  name                 = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.target_group_name}"
  port                 = var.port
  protocol             = var.protocol
  vpc_id               = var.vpc_id
  deregistration_delay = var.deregistration_delay
  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    timeout             = var.health_check_timeout
    interval            = var.health_check_interval
    path                = var.health_check_path
    port                = var.health_check_port
    protocol            = var.health_check_protocol
    matcher             = var.health_check_matcher
  }
  stickiness {
    enabled         = var.stickiness
    type            = "lb_cookie"
    cookie_duration = "86400"
  }
  tags = var.common_tags
}