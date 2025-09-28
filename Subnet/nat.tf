resource "aws_nat_gateway" "nat" {
  count = var.use_nat ? var.use_individual_nat_gateways ? length(aws_subnet.public_subnets) : 1 : 0
  
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = var.use_individual_nat_gateways ? aws_subnet.public_subnets[count.index].id : aws_subnet.public_subnets[0].id
  tags = merge(var.common_tags, {
    Name = "${var.common_tags["env"]}-${var.common_tags["proj"]}-NAT-${substr(var.create_dynamic_subnets ? element(data.aws_availability_zones.az.names, count.index % length(data.aws_availability_zones.az.names)) : var.azs[count.index], -1, 1)}"
  })
}

resource "aws_eip" "nat" {
  count = var.use_nat ? var.use_individual_nat_gateways ? length(aws_subnet.public_subnets) : 1 : 0
  tags = merge(var.common_tags, {
    Name = "${var.common_tags["env"]}-${var.common_tags["proj"]}-NAT-eIP-${substr(var.create_dynamic_subnets ? element(data.aws_availability_zones.az.names, count.index % length(data.aws_availability_zones.az.names)) : var.azs[count.index], -1, 1)}"
  })
}