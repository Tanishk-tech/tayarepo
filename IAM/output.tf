output "s3_readOnly_id" {
  value = aws_iam_policy.readonly_s3_policy[*].id
}

output "s3_readOnly_arn" {
  value = aws_iam_policy.readonly_s3_policy[*].arn
}