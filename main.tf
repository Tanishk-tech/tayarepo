resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = merge(var.common_tags, {
    Name = lower("${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.vpc_name}")
  })
}

resource "aws_internet_gateway" "igw" {
  tags = merge(var.common_tags, {
    Name = lower("${var.common_tags["env"]}-${var.common_tags["proj"]}-Internet-Gateway")
  })
}



resource "aws_internet_gateway_attachment" "igwattach" {
  internet_gateway_id = aws_internet_gateway.igw.id
  vpc_id              = aws_vpc.vpc.id
}

resource "aws_subnet" "public_subnets" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = [for subnet in var.subnets : subnet.cidr_block if subnet.type == "public"][0][count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.common_tags["env"]}-${var.common_tags["proj"]}-Public-Subnet-${substr(var.azs[count.index], -1, 1)}"
    description = "Static Public Subnet"
    type        = "public"
  }
}

resource "aws_subnet" "private_subnets" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = [for subnet in var.subnets : subnet.cidr_block if subnet.type == "private"][0][count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.common_tags["env"]}-${var.common_tags["proj"]}-Private-Subnet-${substr(var.azs[count.index], -1, 1)}"
    description = "Static Private Subnet"
    type        = "private"
  }
}

resource "aws_subnet" "data_subnets" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = [for subnet in var.subnets : subnet.cidr_block if subnet.type == "data"][0][count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.common_tags["env"]}-${var.common_tags["proj"]}-data-Subnet-${substr(var.azs[count.index], -1, 1)}"
    description = "Static data Subnet"
    type        = "data"
  }
}

resource "aws_nat_gateway" "nat" {
  count         = var.use_nat ? var.use_individual_nat_gateways ? length(aws_subnet.public_subnets) : 1 : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = var.use_individual_nat_gateways ? aws_subnet.public_subnets[count.index].id : aws_subnet.public_subnets[0].id
  tags = {
    Name        = "${var.common_tags["env"]}-${var.common_tags["proj"]}-natgw-${substr(var.azs[count.index], -1, 1)}"
  }
}

resource "aws_eip" "nat" {
  count = var.use_nat ? var.use_individual_nat_gateways ? length(aws_subnet.public_subnets) : 1 : 0
  tags = {
    Name = "${var.common_tags["env"]}-${var.common_tags["proj"]}-NAT-eIP-${substr(var.azs[count.index], -1, 1)}"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.common_tags["env"]}-${var.common_tags["proj"]}-RT-Public"
  }
}


resource "aws_route" "public_igw" {
  route_table_id         = aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_subnets_association" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table" "private-rt" {
  count = length(aws_subnet.private_subnets)

  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.common_tags["env"]}-${var.common_tags["proj"]}-RT-Private-${substr(var.azs[count.index], -1, 1)}"
  }
}

resource "aws_route" "private_rt_nat" {
  for_each = { for idx, rt in aws_route_table.private-rt : idx => rt }

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.use_individual_nat_gateways ? aws_nat_gateway.nat[each.key].id : aws_nat_gateway.nat[0].id

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_route_table_association" "private_subnets_association" {
  count          = var.use_nat ? length(aws_subnet.private_subnets) : 0
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private-rt[count.index].id
}


resource "aws_route_table" "data-rt" {
  count = length(aws_subnet.data_subnets)

  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.common_tags["env"]}-${var.common_tags["proj"]}-RT-Data-${substr(var.azs[count.index], -1, 1)}"
  }
}

resource "aws_route_table_association" "data_subnets_association" {
  count          = length(aws_subnet.data_subnets)
  subnet_id      = aws_subnet.data_subnets[count.index].id
  route_table_id = aws_route_table.data-rt[count.index].id
}

resource "aws_key_pair" "keypair" {
  key_name   = "${var.common_tags["env"]}-${var.common_tags["proj"]}-kaypair"
  public_key = var.ec2_pub_keys
}

