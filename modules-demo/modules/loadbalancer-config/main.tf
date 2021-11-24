# Load Balancer
resource "aws_lb" "robertom-terraform-lb-example" {
  name = "robertom-terraform-lb-example"
  internal           = true
  load_balancer_type = "application"
  #  subnets = ["subnet-6d37980a", "subnet-d430f19d"]
  subnets = ["subnet-5f359a38", "subnet-4a32f303"]
  security_groups = [var.asg_id,"sg-adb5a8d5"]
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