resource "aws_internet_gateway" "main" {
  tags = merge(var.common_tags, {
    Name = "${var.common_tags["env"]}-${var.common_tags["proj"]}-Internet-Gateway"
  })
}

resource "aws_internet_gateway_attachment" "igattach" {
  internet_gateway_id = aws_internet_gateway.main.id
  vpc_id              = aws_vpc.vpc.id
}