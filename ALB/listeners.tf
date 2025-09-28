resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.cert_arn
  alpn_policy       = var.alpn_policy

  routing_http_response_server_enabled                                = var.http_server_header
  routing_http_response_strict_transport_security_header_value        = var.sts_header
  routing_http_response_access_control_allow_origin_header_value      = var.cors_allow_origin
  routing_http_response_access_control_allow_methods_header_value     = var.cors_allow_methods
  routing_http_response_access_control_allow_headers_header_value     = var.cors_allow_headers
  routing_http_response_access_control_allow_credentials_header_value = tostring(var.cors_allow_credentials)
  routing_http_response_access_control_expose_headers_header_value    = var.cors_expose_headers
  routing_http_response_access_control_max_age_header_value           = var.cors_max_age
  routing_http_response_content_security_policy_header_value          = var.csp_header
  routing_http_response_x_content_type_options_header_value           = var.x_content_type_options
  routing_http_response_x_frame_options_header_value                  = var.x_frame_options

  routing_http_request_x_amzn_mtls_clientcert_serial_number_header_name = var.mtls_serial_header
  routing_http_request_x_amzn_mtls_clientcert_issuer_header_name        = var.mtls_issuer_header
  routing_http_request_x_amzn_mtls_clientcert_subject_header_name       = var.mtls_subject_header
  routing_http_request_x_amzn_mtls_clientcert_validity_header_name      = var.mtls_validity_header
  routing_http_request_x_amzn_mtls_clientcert_leaf_header_name          = var.mtls_leaf_header
  routing_http_request_x_amzn_mtls_clientcert_header_name               = var.mtls_cert_header
  routing_http_request_x_amzn_tls_version_header_name                   = var.tls_version_header
  routing_http_request_x_amzn_tls_cipher_suite_header_name              = var.tls_cipher_header

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Direct access not allowed!"
      status_code  = "400"
    }
  }

  dynamic "mutual_authentication" {
    for_each = var.enable_mtls ? [1] : []
    content {
      mode            = "verify"
      trust_store_arn = aws_lb_trust_store.mtls[0].arn
    }
  }
}