data "aws_iam_policy_document" "readonly_s3_policy" {
  count = length(var.buckets_readonly)

  statement {
    actions   = ["s3:Get*", "s3:List*"]
    resources = [for bucket in var.buckets_readonly : "arn:aws:s3:::${bucket}/*"]
  }
}


# Create IAM policies
resource "aws_iam_policy" "readonly_s3_policy" {
  count = length(var.buckets_readonly)
  name  = "readonly-s3-policy-${var.buckets_readonly[count.index]}"
  policy = data.aws_iam_policy_document.readonly_s3_policy[count.index].json
}

resource "aws_iam_policy" "write_s3_policy" {
  count = length(var.buckets_write)
  name  = "write-s3-policy-${var.buckets_write[count.index]}"
  policy = data.aws_iam_policy_document.write_s3_policy[count.index].json
}