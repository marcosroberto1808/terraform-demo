# Security Group
resource "aws_security_group" "robertom-terraform-sg-example" {
  name = var.asg_name
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
