provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "robertom-terraform-ec2-example" {
  ami = "ami-0c2d06d50ce30b442"
  instance_type = "t2.micro"
  key_name= "robertom-terraform-test"
  #  subnet_id = "subnet-5f359a38" # PRIVATE-AZ-2A
  #  subnet_id = "subnet-4a32f303" # PRIVATE-AZ-2B
  subnet_id = "subnet-c2e2cd9a" # PRIVATE-AZ-2C

  vpc_security_group_ids = [aws_security_group.robertom-terraform-sg-example.id]
  iam_instance_profile = "PingInstanceRole"
  user_data = file("./scripts/install_nginx.sh")
  tags = {
    Name = "robertom-terraform-ec2-example"
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
    cidr_blocks = ["172.20.178.0/23","15.0.0.0/9","172.20.168.0/22","0.0.0.0/0"]
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
