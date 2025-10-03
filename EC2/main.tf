resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = "${var.common_tags["env"]}-${var.common_tags["proj"]}-keypair"

  tags = merge(
    {
      Name = var.instance_name
    },
    var.common_tags
  )
}
