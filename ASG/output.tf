output "ec2_role_name" {
  value = aws_iam_role.ec2_role.name
}

output "ec2_sg_id" {
  value = aws_security_group.main.id
}

output "ec2_sg_arn" {
  value = aws_security_group.main.arn
}

output "asg_id" {
  value = aws_autoscaling_group.asg.id
}

output "asg_arn" {
  value = aws_autoscaling_group.asg.arn
}