variable "target_group_name" {
  description = "The name of the target group"
  type        = string
}

variable "port" {
  description = "The port on which the targets are listening"
  type        = number
}

variable "protocol" {
  description = "The protocol to use for routing traffic to the targets"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the target group is created"
  type        = string
}

variable "health_check_healthy_threshold" {
  description = "The number of consecutive health check successes required before considering an unhealthy target healthy"
  type        = number
}

variable "health_check_unhealthy_threshold" {
  description = "The number of consecutive health check failures required before considering a target unhealthy"
  type        = number
}

variable "health_check_timeout" {
  description = "The amount of time, in seconds, to wait when receiving a response from the health check"
  type        = number
}

variable "health_check_interval" {
  description = "The approximate amount of time, in seconds, between health checks of an individual target"
  type        = number
}

variable "health_check_path" {
  description = "The destination for the health check request"
  type        = string
}

variable "health_check_port" {
  description = "The port to use for the health check"
  type        = string
}

variable "health_check_protocol" {
  description = "The protocol to use for the health check"
  type        = string
}

variable "common_tags" {
  description = "Tags to apply to the target group"
  type        = map(string)
  default     = {}
}

variable "health_check_matcher" {
  default = "200"
}

variable "deregistration_delay" {
  default = "300"
}

variable "stickiness" {
  default = false
}