output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets.*.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets.*.id
}

output "data_subnet_ids" {
  value = aws_subnet.data_subnets.*.id
}

output "ec2_key_name" {
  value = aws_key_pair.keypair.id
}