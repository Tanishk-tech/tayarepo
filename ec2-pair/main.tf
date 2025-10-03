resource "aws_key_pair" "keypair" {
  key_name   = "${var.common_tags["env"]}-${var.common_tags["proj"]}-keypair"
  public_key = var.public_key
  tags = var.common_tags
}