output "lb_tg_arn" {
  description = "The ARN of the Target Group."
  value       = aws_lb_target_group.robertom-terraform-lb-tg-example.arn
}
