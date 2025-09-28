output "private_subnet_ids" {
  value = aws_subnet.private_subnets.*.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets.*.id
}

output "data_subnet_ids" {
  value = aws_subnet.data_subnets.*.id
}