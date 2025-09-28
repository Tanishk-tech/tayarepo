resource "aws_lb_listener_rule" "main" {
  for_each = { for idx, config in var.listener_rules : idx => config }

  listener_arn = aws_lb_listener.https.arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = each.value.target_group_arn
  }

  # Condition for path pattern
  condition {
    path_pattern {
      values = [each.value.path_pattern]
    }
  }

  # Condition for host header
  condition {
    host_header {
      values = [each.value.host_header]
    }
  }

  tags = {
    Name = "${var.common_tags["env"]}-${var.common_tags["proj"]}-listener-rule-${each.key}"
  }
}