output "asg_id" {
  description = "Security Group ID"
  value       = aws_security_group.robertom-terraform-sg-example.id
}

output "asg_name" {
  description = "Security Group name"
  value       = aws_security_group.robertom-terraform-sg-example.name
}