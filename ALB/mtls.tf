resource "aws_lb_trust_store" "mtls" {
  count = var.enable_mtls ? 1 : 0

  name = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.lb_name}-mTLS"
  ca_certificates_bundle_s3_bucket = var.ca_certificates_bundle_s3_bucket
  ca_certificates_bundle_s3_key    = var.ca_certificates_bundle_s3_key
  # Conditionally include the object version if provided
  ca_certificates_bundle_s3_object_version = var.ca_certificates_bundle_s3_object_version != "" ? var.ca_certificates_bundle_s3_object_version : null
}