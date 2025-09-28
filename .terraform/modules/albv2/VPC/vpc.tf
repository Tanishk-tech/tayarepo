resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = merge(var.common_tags, {
    Name = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.vpc_name}"
  })
}