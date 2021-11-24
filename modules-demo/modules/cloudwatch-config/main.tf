# CloudWatch Metric Cpu High
resource "aws_cloudwatch_metric_alarm" "robertom-terraform-asg-example-cpu-high" {
  alarm_name                = "robertom-terraform-asg-example-cpu-high-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  dimensions = {
    AutoScalingGroupName = var.asg_group_name
  }
  alarm_actions     = [var.asg_scale_up]
}
# CloudWatch Metric Cpu Low
resource "aws_cloudwatch_metric_alarm" "robertom-terraform-asg-example-cpu-low" {
  alarm_name                = "robertom-terraform-asg-example-cpu-low-alarm"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "40"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  dimensions = {
    AutoScalingGroupName = var.asg_group_name
  }
  alarm_actions     = [var.asg_scale_down]
}