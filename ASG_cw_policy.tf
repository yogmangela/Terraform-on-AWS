
# ASG Cloudwatch policy
resource "aws_cloudwatch_metric_alarm" "mission_app_scale_out_alarm" {
  alarm_name          = "${var.namespace}-out-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.mission_app_asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization for Mission App ASG"
  alarm_actions     = [aws_autoscaling_policy.mission_app_scale_out_policy.arn]
}

resource "aws_autoscaling_policy" "mission_app_scale_in_policy" {
  name                   = "${var.namespace}-in-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 180
  autoscaling_group_name = aws_autoscaling_group.mission_app_asg.name
}

# ASG Cloudwatch policy
resource "aws_cloudwatch_metric_alarm" "mission_app_scale_in_alarm" {
  alarm_name          = "${var.namespace}-in-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "20"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.mission_app_asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization for Mission App ASG"
  alarm_actions     = [aws_autoscaling_policy.mission_app_scale_in_policy.arn]
}