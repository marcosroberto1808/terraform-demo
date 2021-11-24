output "asg_group_name" {
  value = aws_autoscaling_group.robertom-terraform-asg-example.name
  description = "The name of the Auto Scale Group."
}

output "asg_scale_up" {
  value = aws_autoscaling_policy.robertom-terraform-asg-example-scale-up.arn
  description = "The ARN of the Auto Scale Group Policy asg_scale_up."
}

output "asg_scale_down" {
  value = aws_autoscaling_policy.robertom-terraform-asg-example-scale-down.arn
  description = "The ARN of the Auto Scale Group Policy asg_scale_down."
}