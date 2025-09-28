# =========================
# SM READONLY POLICY DOCUMENT
# =========================
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "sm_readonly_policy" {
  count = length(var.sm_readonly_arn) > 0 ? 1 : 0

  statement {
    sid    = "SecretsManagerReadOnlyAccess"
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = [
      for secret_arn in var.sm_readonly_arn :
      "${secret_arn}"
    ]
  }
}

# =========================
# SM WRITE POLICY DOCUMENT
# =========================
data "aws_iam_policy_document" "sm_write_policy" {
  count = length(var.sm_write_arn) > 0 ? 1 : 0

  statement {
    sid    = "SecretsManagerWriteAccess"
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:PutSecretValue"
    ]

    resources = [
      for secret_arn in var.sm_write_arn :
      "${secret_arn}"
    ]
  }
}

# =========================
# IAM POLICIES
# =========================
resource "aws_iam_policy" "sm_readonly_policy" {
  count  = length(var.sm_readonly_arn) > 0 ? 1 : 0
  name   = lower("${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-sm-readonly-policy")
  policy = data.aws_iam_policy_document.sm_readonly_policy[0].json

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy" "sm_write_policy" {
  count  = length(var.sm_write_arn) > 0 ? 1 : 0
  name   = lower("${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-sm-write-policy")
  policy = data.aws_iam_policy_document.sm_write_policy[0].json

  lifecycle {
    create_before_destroy = true
  }
}

# =========================
# IAM POLICY ATTACHMENTS
# =========================
resource "aws_iam_policy_attachment" "attach_sm_readonly_policy" {
  count      = length(var.sm_readonly_arn) > 0 ? 1 : 0
  name       = lower("${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-attach-sm-readonly-policy")
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.sm_readonly_policy[0].arn
}

resource "aws_iam_policy_attachment" "attach_sm_write_policy" {
  count      = length(var.sm_write_arn) > 0 ? 1 : 0
  name       = lower("${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-attach-sm-write-policy")
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.sm_write_policy[0].arn
}