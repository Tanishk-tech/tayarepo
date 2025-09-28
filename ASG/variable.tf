variable "vpc_id" {}
variable "ingress_rules" {}
variable "sg_outbond" {}
variable "additional_security_groups" {
  default = []
}

variable "use_lt" {
  description = "Flag to indicate if launch template should be used"
  type        = bool
  default     = true
}


variable "common_tags" {
  description = "Common tags for resources"
  type        = map(string)
  default     = {
    env  = "dev"
    proj = "wf"
  }
}

variable "asg_name" {
  description = "Name of the autoscaling group"
  type        = string
  default     = "asg"
}

variable "user_data" {
  description = "User data to be used on instances"
  type        = string
  default     = ""
}

variable "ami" {
  description = "AMI ID to use for instances"
  type        = string
  default     = ""
}

variable "shutdown_behavior" {
  description = "Instance shutdown behavior"
  type        = string
  default     = "terminate"
}

variable "instance_type" {
  description = "Type of instance to use"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key name to use for instances"
  type        = string
  default     = ""
}

variable "block_device_mappings" {
  description = "Block device mappings"
  type        = list(object({
    device_name = string
    device_size = number
  }))
  default     = []
}

variable "iam_instance_profile" {
  description = "IAM instance profile name"
  type        = string
  default     = ""
}

variable "metadata_options" {
  description = "Metadata options for the instance"
  type        = list(object({
    http_endpoint               = string
    http_tokens                 = string
    http_put_response_hop_limit = number
    instance_metadata_tags      = string
  }))
  default = [{
    http_endpoint               = "enabled"  # Strongest security setting
    http_tokens                 = "required" # Strongest security setting
    http_put_response_hop_limit = 1          # Adjust as needed
    instance_metadata_tags      = "enabled" # Strongest security setting
  }]
}

variable "monitoring_enable" {
  description = "Enable instance monitoring"
  type        = bool
  default     = false
}

variable "is_pub_ip" {
  description = "Assign public IP to instances"
  type        = bool
  default     = false
}


variable "desired_capacity" {
  description = "The desired capacity of the ASG"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "The maximum size of the ASG"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "The minimum size of the ASG"
  type        = number
  default     = 1
}

variable "vpc_subnets" {
  description = "List of VPC subnet IDs"
  type        = list(string)
  default     = []
}

variable "force_delete" {
  description = "Whether to forcefully delete the ASG"
  type        = bool
  default     = false
}

variable "health_check_type" {
  description = "The health check type for the ASG"
  type        = string
  default     = "EC2"
}

variable "health_check_grace_period" {
  description = "The health check grace period for the ASG"
  type        = number
  default     = 300
}


variable "isCouldWatchLogs" {
  default = false
}

# Define S3 policies
variable "buckets_readonly" {
  type        = list(string)
  description = "List of S3 buckets for read-only access"
  default = []
}

variable "buckets_write" {
  type        = list(string)
  description = "List of S3 buckets for write access"
    default = []
}


variable "ssm_ssh" {
  default = false
}

variable "isCouldWatchAgentPerm" {
  default = false
}

variable "tg_arn" {
    default = null
}

variable "kms_id" {
  default = ""
}

variable "asg_termination_policy" {
  default = ["Default"]
}


# CPU Auto-Scaling Configuration
variable "auto_scale_on_cpu" {
  description = "Enable or disable auto-scaling based on CPU utilization"
  type        = bool
  default     = false
}

variable "cpu_threshold_max" {
  description = "CPU utilization threshold for scaling"
  type        = number
  default     = 75
}

variable "cpu_threshold_min" {
  description = "CPU utilization threshold for scaling"
  type        = number
  default     = 50
}

variable "cpu_period" {
  description = "CPU metric period in seconds"
  type        = number
  default     = 300
}

variable "cpu_statistic" {
  description = "Statistic for CPU metric"
  type        = string
  default     = "Maximum"
}

variable "cpu_evaluation_periods" {
  description = "Number of evaluation periods for CPU alarm"
  type        = number
  default     = 1
}

# RAM Auto-Scaling Configuration
variable "auto_scale_on_ram" {
  description = "Enable or disable auto-scaling based on RAM utilization"
  type        = bool
  default     = false
}

variable "ram_threshold_max" {
  description = "RAM utilization threshold for scaling"
  type        = number
  default     = 80
}

variable "ram_threshold_min" {
  description = "RAM utilization threshold for scaling"
  type        = number
  default     = 40
}
variable "ram_period" {
  description = "RAM metric period in seconds"
  type        = number
  default     = 300
}

variable "ram_statistic" {
  description = "Statistic for RAM metric"
  type        = string
  default     = "Maximum"
}

variable "ram_evaluation_periods" {
  description = "Number of evaluation periods for RAM alarm"
  type        = number
  default     = 1
}

# Scaling Adjustments
variable "scaling_adjustment_up" {
  description = "Scaling adjustment when scaling out"
  type        = number
  default     = 1
}

variable "scaling_adjustment_down" {
  description = "Scaling adjustment when scaling in"
  type        = number
  default     = -1
}

variable "alerts_enabled" {
  default = true
}

variable "alarm_actions" {
  default = []
}

# Disk Utilization Variables
variable "disk_evaluation_periods" {
  description = "Number of periods to evaluate for disk utilization"
  type        = number
  default     = 1
}

variable "disk_threshold" {
  description = "Threshold for disk utilization alarm"
  type        = number
  default     = 80
}

variable "disk_period" {
  description = "Period for the disk utilization alarm (in seconds)"
  type        = number
  default     = 300
}

variable "disk_statistic" {
  description = "Statistic for disk utilization alarm (e.g., Average, Sum)"
  type        = string
  default     = "Maximum"
}

variable "root_volume_size" {
  description = "Statistic for disk utilization alarm (e.g., Average, Sum)"
  type        = number
  default     = 30
}
variable "sm_readonly_arn" {
  default = []
}

variable "sm_write_arn" {
  default = []
}