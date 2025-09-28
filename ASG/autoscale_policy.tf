resource "aws_cloudwatch_metric_alarm" "cpu_alarm_max" {
  count               = var.alerts_enabled ? 1 : 0
  alarm_name          = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-CPU-ScaleUP"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.cpu_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.cpu_period
  statistic           = var.cpu_statistic
  threshold           = var.cpu_threshold_max
  alarm_actions       = var.auto_scale_on_cpu ? [aws_autoscaling_policy.cpu_scale_out[count.index].arn] : []
  ok_actions          = var.alarm_actions
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm_min" {
  count               = var.alerts_enabled ? 1 : 0
  alarm_name          = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-CPU-ScaleDown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.cpu_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.cpu_period
  statistic           = var.cpu_statistic
  threshold           = var.cpu_threshold_min
  alarm_actions       = var.auto_scale_on_cpu ? [aws_autoscaling_policy.cpu_scale_in[count.index].arn] : []
  ok_actions          = var.alarm_actions
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "ram_alarm_max" {
  count               = var.alerts_enabled ? 1 : 0
  alarm_name          = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-RAM-ScaleUP"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.ram_evaluation_periods
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = var.ram_period
  statistic           = var.ram_statistic
  threshold           = var.ram_threshold_max
  alarm_actions       = var.auto_scale_on_ram ? [aws_autoscaling_policy.ram_scale_out[count.index].arn] : []
  ok_actions          = var.alarm_actions
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "ram_alarm_min" {
  count               = var.alerts_enabled ? 1 : 0
  alarm_name          = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-RAM-ScaleDown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.ram_evaluation_periods
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = var.ram_period
  statistic           = var.ram_statistic
  threshold           = var.ram_threshold_min
  alarm_actions       = var.auto_scale_on_ram ? [aws_autoscaling_policy.ram_scale_in[count.index].arn] : []
  ok_actions          = var.alarm_actions
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "disk_alarm" {
  count               = var.alerts_enabled ? 1 : 0
  alarm_name          = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-High-Disk-Utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.disk_evaluation_periods
  metric_name         = "disk_used_percent"  # Correct metric name for disk used percentage
  namespace           = "CWAgent"             # Ensure this matches your CWAgent configuration
  period              = var.disk_period
  statistic           = var.disk_statistic
  threshold           = var.disk_threshold

  alarm_actions       = var.alarm_actions
  ok_actions          = var.alarm_actions

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}


resource "aws_autoscaling_policy" "cpu_scale_out" {
  count                  = var.auto_scale_on_cpu ? 1 : 0
  name                   = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-cpu-scaleOut"
  scaling_adjustment      = var.scaling_adjustment_up
  adjustment_type         = "ChangeInCapacity"
  autoscaling_group_name  = aws_autoscaling_group.asg.name
  cooldown                = 300
}

resource "aws_autoscaling_policy" "cpu_scale_in" {
  count                  = var.auto_scale_on_cpu ? 1 : 0
  name                   = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-cpu-scaleIn"
  scaling_adjustment      = var.scaling_adjustment_down
  adjustment_type         = "ChangeInCapacity"
  autoscaling_group_name  = aws_autoscaling_group.asg.name
  cooldown                = 300
}

resource "aws_autoscaling_policy" "ram_scale_out" {
  count                  =  var.auto_scale_on_ram ? 1 : 0
  name                   = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-ram-scaleOut"
  scaling_adjustment      = var.scaling_adjustment_up
  adjustment_type         = "ChangeInCapacity"
  autoscaling_group_name  = aws_autoscaling_group.asg.name
  cooldown                = 300
}

resource "aws_autoscaling_policy" "ram_scale_in" {
  count                  = var.auto_scale_on_ram ? 1 : 0
  name                   = "${var.common_tags["env"]}-${var.common_tags["proj"]}-${var.asg_name}-ram-scaleIn"
  scaling_adjustment      = var.scaling_adjustment_down
  adjustment_type         = "ChangeInCapacity"
  autoscaling_group_name  = aws_autoscaling_group.asg.name
  cooldown                = 300
}