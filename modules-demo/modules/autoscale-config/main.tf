# Launch Configuration
resource "aws_launch_configuration" "robertom-terraform-lc-example" {
  name = var.lc_settings.name
  image_id = var.lc_settings.image_id
  instance_type = var.lc_settings.instance_type
  key_name= var.lc_settings.key_name
  security_groups = [var.lc_settings.asg_id]
  iam_instance_profile = aws_iam_instance_profile.robertom-instance-profile.name
  user_data = file("${path.module}/install_nginx.sh")
  lifecycle {
    create_before_destroy = true
  }
}

# Autoscale Group
resource "aws_autoscaling_group" "robertom-terraform-asg-example" {
  name = "robertom-terraform-asg-example"
  launch_configuration = aws_launch_configuration.robertom-terraform-lc-example.name
  vpc_zone_identifier = ["subnet-5f359a38", "subnet-4a32f303"]
  min_size = var.lc_settings.asg_min_size
  max_size = var.lc_settings.asg_max_size
  target_group_arns = [var.lc_settings.lb_tg_arn]
  #  health_check_type = "ELB"
  health_check_grace_period = 300
  health_check_type = "EC2"

  tag {
    key = "Name"
    value = "robertom-terraform-asg-example"
    propagate_at_launch = true
  }
}

# Autoscale Group Scale Up
resource "aws_autoscaling_policy" "robertom-terraform-asg-example-scale-up" {
  name = "robertom-terraform-asg-example-scale-up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 120
  autoscaling_group_name = aws_autoscaling_group.robertom-terraform-asg-example.name
}

# Autoscale Group Scale Down
resource "aws_autoscaling_policy" "robertom-terraform-asg-example-scale-down" {
  name = "robertom-terraform-asg-example-scale-down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 120
  autoscaling_group_name = aws_autoscaling_group.robertom-terraform-asg-example.name
}

# aws_iam_instance_profile
resource "aws_iam_instance_profile" "robertom-instance-profile" {
  name = "robertom-instance-profile"
  role = "robertom-instance-role"
}