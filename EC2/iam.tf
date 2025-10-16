resource "aws_iam_role" "ec2_role" {
  name = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.instance_name}-IAM-ROLE"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = var.common_tags
}

data "aws_iam_policy_document" "ssm_session_policy" {
  statement {
    actions = [
      "ssm:UpdateInstanceInformation",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ssm_session_policy" {
  count  = var.ssm_ssh ? 1 : 0
  name   = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.instance_name}-SSM-Session-Policy"
  policy = data.aws_iam_policy_document.ssm_session_policy.json
  lifecycle {
    create_before_destroy = true
  }

  tags = var.common_tags
}


resource "aws_iam_policy_attachment" "attach_ssm_policy" {
  count      = var.ssm_ssh ? 1 : 0
  name       = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.instance_name}-attach-SSM-Session-Policy"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.ssm_session_policy[count.index].arn
}