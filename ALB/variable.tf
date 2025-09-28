variable "lb_name" {
  description = "Name of the load balancer"
}

variable "lb_internal" {
  description = "Whether the load balancer is internal or not"
  default     = false
}

variable "lb_type" {
  description = "Type of the load balancer"
  default     = "application"
}

variable "lb_subnets" {
  description = "List of subnet IDs for the load balancer"
  type        = list(string)
}

variable "host_preserve" {
  description = "Whether to preserve the host header in requests"
  default     = false
}

variable "lb_del_protection" {
  description = "Whether deletion protection is enabled for the load balancer"
  default     = true
}

variable "lb_logs_bucket_id" {
  description = "ID of the S3 bucket to store load balancer access logs"
}

variable "lb_logs_prefix" {
  description = "Prefix for the load balancer access logs"
}

variable "lb_logs_enabled" {
  description = "Whether access logging is enabled for the load balancer"
  default     = false
}

variable "common_tags" {}
variable "enable_access_logs" {}


variable "ingress_rules" {
  description = "List of ingress rules"
  default     = []
}
variable "sg_outbond" {
  default = []
}
variable "vpc_id" {
  default = ""
}


variable "ssl_policy" {}
variable "cert_arn" {}



variable "listener_rules" {
  description = "List of listener rules for the ALB"
  type = list(object({
    path_pattern     = string
    host_header      = string
    priority         = number
    target_group_arn = string
  }))
}


variable "enable_mtls" {
  description = "Whether to enable mTLS"
  type        = bool
  default     = false
}

variable "ca_certificates_bundle_s3_bucket" {
  description = "S3 bucket for CA certificates bundle"
  type        = string
  default     = ""
}

variable "ca_certificates_bundle_s3_key" {
  description = "S3 key for CA certificates bundle"
  type        = string
  default     = ""
}

variable "ca_certificates_bundle_s3_object_version" {
  description = "Version Id of CA bundle S3 bucket object, if versioned"
  type        = string
  default     = ""
}



variable "alpn_policy" {
  description = "The Application-Layer Protocol Negotiation (ALPN) policy"
  type        = string
  default     = "HTTP2Preferred"
}

variable "http_server_header" {
  description = "Enable/Disable HTTP response server header"
  type        = bool
  default     = false
}

variable "sts_header" {
  description = "Strict-Transport-Security header"
  type        = string
  default     = "max-age=31536000; includeSubDomains; preload"
}

variable "cors_allow_origin" {
  description = "CORS allow origin"
  type        = string
  default     = "="
}

variable "cors_allow_methods" {
  description = "CORS allow methods"
  type        = string
  default     = ""
}

variable "cors_allow_headers" {
  description = "CORS allow headers"
  type        = string
  default     = ""
}

variable "cors_allow_credentials" {
  description = "CORS allow credentials"
  type        = bool
  default     = ""
}

variable "cors_expose_headers" {
  description = "CORS expose headers"
  type        = string
  default     = ""
}

variable "cors_max_age" {
  description = "CORS max age in seconds"
  type        = number
  default     = 0
}

variable "csp_header" {
  description = "Content-Security-Policy header"
  type        = string
  default     = ""
}

variable "x_content_type_options" {
  description = "X-Content-Type-Options header"
  type        = string
  default     = "nosniff"
}

variable "x_frame_options" {
  description = "X-Frame-Options header"
  type        = string
  default     = "SAMEORIGIN"
}

# mTLS and TLS request header renaming
variable "mtls_serial_header" {
  description = "X-Amzn-Mtls-Clientcert-Serial-Number header name"
  type        = string
  default     = "x-ae-mtls-clientcert-serial-number"
}

variable "mtls_issuer_header" {
  description = "X-Amzn-Mtls-Clientcert-Issuer header name"
  type        = string
  default     = "x-ae-mtls-clientcert-issuer"
}

variable "mtls_subject_header" {
  description = "X-Amzn-Mtls-Clientcert-Subject header name"
  type        = string
  default     = "x-ae-mtls-clientcert-subject"
}

variable "mtls_validity_header" {
  description = "X-Amzn-Mtls-Clientcert-Validity header name"
  type        = string
  default     = "x-ae-mtls-clientcert-validity"
}

variable "mtls_leaf_header" {
  description = "X-Amzn-Mtls-Clientcert-Leaf header name"
  type        = string
  default     = "x-ae-mtls-clientcert-leaf"
}

variable "mtls_cert_header" {
  description = "X-Amzn-Mtls-Clientcert header name"
  type        = string
  default     = "x-ae-mtls-clientcert"
}

variable "tls_version_header" {
  description = "X-Amzn-Tls-Version header name"
  type        = string
  default     = "x-ae-tls-version"
}

variable "tls_cipher_header" {
  description = "X-Amzn-Tls-Cipher-Suite header name"
  type        = string
  default     = "x-ae-tls-cipher-suite"
}