resource "aws_s3_bucket" "s3" {
  bucket = lower("${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.s3_name}")

  tags = merge(var.common_tags, {
    Name = var.s3_name
  })
}

resource "aws_s3_bucket_ownership_controls" "s3_ownership" {
  bucket = aws_s3_bucket.s3.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "s3_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.s3_ownership]
  bucket = aws_s3_bucket.s3.id
  acl    = var.s3_acl
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.s3.id
  versioning_configuration {
    status = var.s3_versioning
  }
}

resource "aws_s3_bucket_website_configuration" "s3_website" {
  count     = var.s3_enable_website ? 1 : 0
  bucket    = aws_s3_bucket.s3.id

  index_document {
    suffix = var.s3_index_document
  }

  error_document {
    key = var.s3_error_document
  }

 dynamic "routing_rule" {
    for_each = var.s3_routing_rules
    content {
      condition {
        key_prefix_equals = routing_rule.value["condition"]
      }
      redirect {
        replace_key_prefix_with = routing_rule.value["replace_key_prefix_with"]
      }
    }
  }
}


# resource "aws_s3_object" "folders" {
#   for_each = toset(var.folders)
#   key                    = "${each.value}"
#   bucket                 = aws_s3_bucket.s3.id
#   source                 = ""
#   server_side_encryption = "aws:kms"
#   content {
#     source  = "/dev/null"  # Use a placeholder source (like /dev/null) to create an empty object
#     encoding = "none"  # Ensure no encoding is applied
#   }
# }