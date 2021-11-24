provider "aws" {
  region = "us-west-2"
}

# Launch Configuration
resource "aws_launch_configuration" "robertom-terraform-lc-example" {
  name = "robertom-terraform-lc-example"
  image_id = "ami-0c2d06d50ce30b442"
  instance_type = "t2.micro"
  key_name= "robertom-terraform-test"
  security_groups = [aws_security_group.robertom-terraform-sg-example.id]
  iam_instance_profile = "PingInstanceRole"
  user_data = file("./scripts/install_nginx.sh")
  lifecycle {
    create_before_destroy = true
  }
}

# Autoscale Group
resource "aws_autoscaling_group" "robertom-terraform-asg-example" {
  name = "robertom-terraform-asg-example"
  launch_configuration = aws_launch_configuration.robertom-terraform-lc-example.name
  vpc_zone_identifier = ["subnet-5f359a38", "subnet-4a32f303"]
  min_size = 1
  max_size = 4
  target_group_arns = [aws_lb_target_group.robertom-terraform-lb-tg-example.arn]
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
    AutoScalingGroupName = aws_autoscaling_group.robertom-terraform-asg-example.name
  }
  alarm_actions     = [aws_autoscaling_policy.robertom-terraform-asg-example-scale-up.arn]
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
    AutoScalingGroupName = aws_autoscaling_group.robertom-terraform-asg-example.name
  }
  alarm_actions     = [aws_autoscaling_policy.robertom-terraform-asg-example-scale-down.arn]
}

# Load Balancer
resource "aws_lb" "robertom-terraform-lb-example" {
  name = "robertom-terraform-lb-example"
  internal           = true
  load_balancer_type = "application"
#  subnets = ["subnet-6d37980a", "subnet-d430f19d"]
  subnets = ["subnet-5f359a38", "subnet-4a32f303"]
  security_groups = [aws_security_group.robertom-terraform-sg-example.id,"sg-adb5a8d5"]
  enable_deletion_protection = false

}

# LB Listener
resource "aws_lb_listener" "robertom-terraform-lb-listener-example" {
  load_balancer_arn = aws_lb.robertom-terraform-lb-example.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

# LB Listener Rule
resource "aws_lb_listener_rule" "robertom-terraform-lb-listener-rule-example" {
  listener_arn = aws_lb_listener.robertom-terraform-lb-listener-example.arn
  priority = 100
  condition {
    path_pattern {
      values = ["*"]
    }
  }
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.robertom-terraform-lb-tg-example.arn
  }
}

# Target Group
resource "aws_lb_target_group" "robertom-terraform-lb-tg-example" {
  name     = "robertom-terraform-lb-tg-example"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-faf77d9d"
  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

# Security Group
resource "aws_security_group" "robertom-terraform-sg-example" {
  name = "robertom-terraform-sg-example"
  vpc_id = "vpc-faf77d9d"
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["172.20.178.0/23","15.0.0.0/9","172.20.168.0/22"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["172.20.178.0/23","15.0.0.0/9","172.20.168.0/22"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["172.20.178.0/23","15.0.0.0/9","172.20.168.0/22"]
  }
  egress {
    from_port = -1
    to_port = -1
    protocol = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "robertom-terraform-sg-example"
  }
}
