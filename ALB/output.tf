output "lb_id" {
  value = aws_lb.lb.id
}

output "lb_dns_name" {
  value = aws_lb.lb.dns_name
}

output "sg_id" {
  value = aws_security_group.main.id
}