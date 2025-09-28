resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "${var.common_tags["env"]}-${var.common_tags["proj"]}-RT-Public"
  })
}

resource "aws_route" "public_igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id
}

resource "aws_route_table_association" "public_subnets_association" {
  count = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private-rt" {
  count = length(aws_subnet.private_subnets)

  vpc_id = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "${var.common_tags["env"]}-${var.common_tags["proj"]}-RT-Private-${substr(var.create_dynamic_subnets ? element(data.aws_availability_zones.az.names, count.index % length(data.aws_availability_zones.az.names)) : var.azs[count.index], -1, 1)}"
  })
}

resource "aws_route" "private-rt-nat" {
  count = var.use_nat ? length(aws_subnet.private_subnets) : 0

  route_table_id         = aws_route_table.private-rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.use_individual_nat_gateways ? aws_nat_gateway.nat[count.index].id : aws_nat_gateway.nat[0].id
}

resource "aws_route_table_association" "private_subnets_association" {
  count = var.use_nat ? length(aws_subnet.private_subnets) : 0
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private-rt[count.index].id
}


resource "aws_route_table" "data-rt" {
  count = length(aws_subnet.data_subnets)

  vpc_id = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "${var.common_tags["env"]}-${var.common_tags["proj"]}-RT-Data-${substr(var.create_dynamic_subnets ? element(data.aws_availability_zones.az.names, count.index % length(data.aws_availability_zones.az.names)) : var.azs[count.index], -1, 1)}"
  })
}

resource "aws_route_table_association" "data_subnets_association" {
  count = length(aws_subnet.data_subnets)
  subnet_id      = aws_subnet.data_subnets[count.index].id
  route_table_id = aws_route_table.data-rt[count.index].id
}