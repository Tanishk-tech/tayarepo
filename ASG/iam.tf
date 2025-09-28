resource "aws_iam_role" "ec2_role" {
  name = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-IAM-ROLE"
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
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-PROFILE"
  role = aws_iam_role.ec2_role.name
}



data "aws_iam_policy_document" "readonly_s3_policy" {
  count = length(var.buckets_readonly) > 0 ? 1 : 0

  statement {
    actions = ["s3:Get*", "s3:List*"]
    resources = flatten([
      for bucket in var.buckets_readonly : [
        "arn:aws:s3:::${bucket}",
        "arn:aws:s3:::${bucket}/*"
      ]
    ])
  }

}

data "aws_iam_policy_document" "write_s3_policy" {
  count = length(var.buckets_write) > 0 ? 1 : 0

  statement {
    actions   = ["s3:Get*", "s3:List*", "s3:PutObject"]
     resources = flatten([
      for bucket in var.buckets_write : [
        "arn:aws:s3:::${bucket}",
        "arn:aws:s3:::${bucket}/*"
      ]
    ])
  }
}

# Create IAM policies
resource "aws_iam_policy" "readonly_s3_policy" {
  count  = length(var.buckets_readonly) > 0 ? 1 : 0
  name   = lower("${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-readonly-s3-policy")
  policy = data.aws_iam_policy_document.readonly_s3_policy[0].json
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy" "write_s3_policy" {
  count  = length(var.buckets_write) > 0 ? 1 : 0
  name   = lower("${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-write-s3-policy")
  policy = data.aws_iam_policy_document.write_s3_policy[0].json
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy_attachment" "attach_readonly_s3_policy" {
  count      = length(var.buckets_readonly) > 0 ? 1 : 0
  name       = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-attach-readonly-s3-policy"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.readonly_s3_policy[0].arn
}

resource "aws_iam_policy_attachment" "attach_write_s3_policy" {
  count      = length(var.buckets_write) > 0 ? 1 : 0
  name       = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-attach-write-s3-policy"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.write_s3_policy[0].arn
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
  name   = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-SSM-Session-Policy"
  policy = data.aws_iam_policy_document.ssm_session_policy.json
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_iam_policy_attachment" "attach_ssm_policy" {
  count      = var.ssm_ssh ? 1 : 0
  name       = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-attach-SSM-Session-Policy"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.ssm_session_policy[count.index].arn
}



data "aws_iam_policy_document" "cwa" {
  statement {
    actions = [
      "cloudwatch:PutMetricData",
      "ec2:DescribeVolumes",
      "ec2:DescribeTags"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "ssm:GetParameter"
    ]
    resources = ["arn:aws:ssm:::parameter/AmazonCloudWatch-*"]
  }
}

data "aws_iam_policy_document" "cwa-logs" {
  statement {
    actions = [
      "ec2:DescribeVolumes",
      "ec2:DescribeTags",
      "logs:PutLogEvents",
      "logs:PutRetentionPolicy",
      "logs:DescribeLogStreams",
      "logs:DescribeLogGroups",
      "logs:CreateLogStream",
      "logs:CreateLogGroup"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "ssm:GetParameter"
    ]
    resources = ["arn:aws:ssm:::parameter/AmazonCloudWatch-*"]
  }
}

resource "aws_iam_policy" "cwa" {
  count  = var.isCouldWatchAgentPerm ? 1 : 0
  name   = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-CWA-Policy"
  policy = data.aws_iam_policy_document.cwa.json
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy_attachment" "cwa" {
  count      = var.isCouldWatchAgentPerm ? 1 : 0
  name       = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-attach-CWA-Policy"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.cwa[count.index].arn
}

resource "aws_iam_policy" "cwa-logs" {
  count  = var.isCouldWatchLogs ? 1 : 0
  name   = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-CWA-Logs-Policy"
  policy = data.aws_iam_policy_document.cwa-logs.json
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy_attachment" "cwa-logs" {
  count      = var.isCouldWatchLogs ? 1 : 0
  name       = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-attach-CWA-logs-Policy"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.cwa-logs[count.index].arn
}