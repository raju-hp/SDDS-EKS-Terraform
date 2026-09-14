resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/eks/${var.cluster_name}/sdds"
  retention_in_days = var.log_retention_days

  tags = var.tags
}
