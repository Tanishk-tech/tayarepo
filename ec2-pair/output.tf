output "ec2_key_name" {
  value = aws_key_pair.keypair.id
}