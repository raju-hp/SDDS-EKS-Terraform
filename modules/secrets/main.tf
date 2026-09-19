data "aws_partition" "current" {}

data "aws_iam_policy_document" "sdds_secrets" {
  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = [aws_secretsmanager_secret.this.arn]
  }
}

resource "aws_secretsmanager_secret" "this" {
  name                    = var.secret_name
  description             = "SDDS application credentials"
  recovery_window_in_days = 7

  lifecycle {
    prevent_destroy = true
  }

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "this" {
  count = var.password == null ? 0 : 1

  secret_id = aws_secretsmanager_secret.this.id

  secret_string = jsonencode({
    username = var.username
    password = var.password
  })
}

resource "aws_iam_role" "pod" {
  name = "${replace(var.secret_name, "/", "-")}-pod-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "pods.eks.amazonaws.com"
      }
      Action = [
        "sts:AssumeRole",
        "sts:TagSession"
      ]
    }]
  })

  inline_policy {
    name   = "read-sdds-secret"
    policy = data.aws_iam_policy_document.sdds_secrets.json
  }

  tags = var.tags
}

resource "aws_eks_pod_identity_association" "sdds" {
  cluster_name    = var.cluster_name
  namespace       = var.namespace
  service_account = var.service_account
  role_arn        = aws_iam_role.pod.arn
}
