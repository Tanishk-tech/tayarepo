resource "aws_iam_role" "key_admin" {
  name = "${var.common_tags["env"]}-${var.common_tags["proj"]}-kms-admin"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role" "key_user" {
  name = "${var.common_tags["env"]}-${var.common_tags["proj"]}-kms-user"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}


data "aws_caller_identity" "current" {}

resource "aws_kms_key" "aws_kms" {
  description             = "${var.common_tags["env"]}-${var.common_tags["proj"]}-kms"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "Enable IAM User Permissions",
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action    = "kms:*",
        Resource  = "*"
      },
      {
        Sid       = "Allow access for key administrators",
        Effect    = "Allow",
        Principal = {
          AWS = "${aws_iam_role.key_admin.arn}"
        },
        Action    = [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ],
        Resource  = "*"
      },
      {
        Sid       = "Allow use of the key",
        Effect    = "Allow",
        Principal = {
          AWS = "*"
        },
        Action    = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource  = "*"
      },
      {
        Sid       = "Allow attachment of persistent resources",
        Effect    = "Allow",
        Principal = {
          AWS = "*"
        },
        Action    = [
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:RevokeGrant"
        ],
        Resource  = "*",
        Condition = {
          Bool = {
            "kms:GrantIsForAWSResource" : "true"
          }
        }
      }
    ]
  })
}

resource "aws_kms_alias" "alias" {
  name          = "alias/${var.common_tags["env"]}-${var.common_tags["proj"]}-kms"
  target_key_id = aws_kms_key.aws_kms.key_id
}