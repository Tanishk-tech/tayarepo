data "aws_ami" "selected" {
  most_recent = false
  owners      = ["self", "amazon"]
  filter {
    name   = "image-id"
    values = [var.ami]
  }
}

locals {
  block_device_list = flatten([
    for bd in data.aws_ami.selected.block_device_mappings : [
      {
        device_name = bd.device_name
        ebs         = try(bd.ebs, null) # Ensures ebs exists, otherwise null
      }
    ]
  ])

  # Get first block device if available
  first_block_device = length(local.block_device_list) > 0 ? one(local.block_device_list) : null

  # Extract values safely
  ami_root_size    = try(local.first_block_device.ebs.volume_size, null)
  is_ami_encrypted = try(local.first_block_device.ebs.encrypted, false)

  final_root_size  = var.root_volume_size > coalesce(local.ami_root_size, 0) ? var.root_volume_size : local.ami_root_size
}



resource "aws_launch_template" "lt" {
  count                                = var.use_lt ? 1 : 0
  name                                 = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-lt"
  vpc_security_group_ids               = concat([aws_security_group.main.id], var.additional_security_groups)
  user_data                            = var.user_data
  image_id                             = var.ami
  instance_initiated_shutdown_behavior = var.shutdown_behavior
  instance_type                        = var.instance_type
  key_name                             = var.key_name

 block_device_mappings {
    device_name = data.aws_ami.selected.root_device_name
    ebs {
      delete_on_termination = true
      volume_size           = local.final_root_size
      volume_type           = "gp3" 
      encrypted             = local.is_ami_encrypted ? null : true
      kms_key_id             = local.is_ami_encrypted ? null : (var.kms_id != "" ? var.kms_id : null)
    }
  }

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings
    content {
      device_name = block_device_mappings.value.device_name
      
      ebs {
        volume_size           = block_device_mappings.value.device_size
        delete_on_termination = true
        encrypted             = true
        volume_type           = "gp3"
        kms_key_id            = var.kms_id != "" ? var.kms_id : null
      }
    }
  }

  iam_instance_profile {
      name = aws_iam_instance_profile.ec2_profile.name
  }

dynamic "metadata_options" {
    for_each = var.metadata_options
    content {
      http_endpoint               = metadata_options.value.http_endpoint
      http_tokens                 = metadata_options.value.http_tokens
      http_put_response_hop_limit = metadata_options.value.http_put_response_hop_limit
      instance_metadata_tags      = metadata_options.value.instance_metadata_tags
    }
  }

  monitoring {
      enabled = var.monitoring_enable
  }

}

resource "aws_autoscaling_group" "asg" {
  name                      = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}"
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  min_size                  = var.min_size
  vpc_zone_identifier       = var.vpc_subnets
  force_delete              = var.force_delete
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  target_group_arns         = var.tg_arn
  termination_policies      = var.asg_termination_policy
  launch_template {
    id      = aws_launch_template.lt[0].id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}"
    propagate_at_launch = true
  }
}