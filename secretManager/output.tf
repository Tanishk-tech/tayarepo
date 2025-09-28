output "secret_arn" {
  value = aws_secretsmanager_secret.secretManager.arn
}

output "secret_name" {
  value = aws_secretsmanager_secret.secretManager.name
}