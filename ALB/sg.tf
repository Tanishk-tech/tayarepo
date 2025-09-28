resource "aws_security_group" "main" {
  name        = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.lb_name}-SG"
  description = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.lb_name} security group for ALB"
vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value["description"]
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
      security_groups  = try(ingress.value["security_groups"], [])
      self = try(ingress.value["self"], false)
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.sg_outbond
  }
}