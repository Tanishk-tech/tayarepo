resource "aws_subnet" "public_subnets" {
  count = var.create_dynamic_subnets ? length(data.aws_availability_zones.az.names) : length(var.azs)

  vpc_id = var.vpc_id

  cidr_block        = var.create_dynamic_subnets ? "10.0.${count.index + 1}.0/24" : [for subnet in var.subnets : subnet.cidr_block if subnet.type == "public"][0][count.index]
  availability_zone = var.create_dynamic_subnets ? data.aws_availability_zones.az.names[count.index % length(data.aws_availability_zones.az.names)] : var.azs[count.index]

  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name        = "${var.common_tags["env"]}-${var.common_tags["proj"]}-Public-Subnet-${substr(var.create_dynamic_subnets ? element(data.aws_availability_zones.az.names, count.index % length(data.aws_availability_zones.az.names)) : var.azs[count.index], -1, 1)}"
    description = "${var.create_dynamic_subnets ? "Dynamic" : "Static"} Public Subnet"
    type        = "public"
  })
}

resource "aws_subnet" "private_subnets" {
  count = var.create_dynamic_subnets ? length(data.aws_availability_zones.az.names) : length(var.azs)

  vpc_id = var.vpc_id

  cidr_block        = var.create_dynamic_subnets ? "10.1.${count.index + 1}.0/24" : [for subnet in var.subnets : subnet.cidr_block if subnet.type == "private"][0][count.index]
  availability_zone = var.create_dynamic_subnets ? data.aws_availability_zones.az.names[count.index % length(data.aws_availability_zones.az.names)] : var.azs[count.index]

  map_public_ip_on_launch = false

  tags = merge(var.common_tags, {
    Name        = "${var.common_tags["env"]}-${var.common_tags["proj"]}-Private-Subnet-${substr(var.create_dynamic_subnets ? element(data.aws_availability_zones.az.names, count.index % length(data.aws_availability_zones.az.names)) : var.azs[count.index], -1, 1)}"
    Description = "${var.create_dynamic_subnets ? "Dynamic" : "Static"} Private Subnet"
    type        = "private"
  })
}


resource "aws_subnet" "data_subnets" {
  count = var.create_dynamic_subnets ? (contains(var.dynamic_subnet_types, "data") ? try(length(data.aws_availability_zones.az.names), 0) : 0) : (contains(var.dynamic_subnet_types, "data") ? length(var.azs) : 0)

  vpc_id = var.vpc_id

  cidr_block        = var.create_dynamic_subnets ? "10.2.${count.index + 1}.0/24" : [for subnet in var.subnets : subnet.cidr_block if subnet.type == "data"][0][count.index]
  availability_zone = var.create_dynamic_subnets ? data.aws_availability_zones.az.names[count.index % length(data.aws_availability_zones.az.names)] : var.azs[count.index]

  map_public_ip_on_launch = false

  tags = merge(var.common_tags, {
    Name        = "${var.common_tags["env"]}-${var.common_tags["proj"]}-Data-Subnet-${substr(var.create_dynamic_subnets ? element(data.aws_availability_zones.az.names, count.index % length(data.aws_availability_zones.az.names)) : var.azs[count.index], -1, 1)}"
    Description = "${var.create_dynamic_subnets ? "Dynamic" : "Static"} Data Subnet"
    type        = "data"
  })
}