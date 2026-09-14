output "secret_arn" {
  value = aws_secretsmanager_secret.this.arn
}

output "pod_role_arn" {
  value = aws_iam_role.pod.arn
}
