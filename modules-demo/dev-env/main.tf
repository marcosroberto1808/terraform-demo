provider "aws" {
  region = "us-west-2"
}

module "autoscale-config" {
  source    = "../modules/autoscale-config"
  lc_settings = {
    name = "robertom-terraform-lc-example"
    image_id = "ami-0c2d06d50ce30b442"
    instance_type = "t2.micro"
    key_name= "robertom-terraform-test"
    asg_max_size = 4
    asg_min_size = 2
    asg_id = module.securitygroup-config.asg_id
    lb_tg_arn = module.loadbalancer-config.lb_tg_arn
  }
}

module "cloudwatch-config" {
  source = "../modules/cloudwatch-config"
  asg_group_name = module.autoscale-config.asg_group_name
  asg_scale_up = module.autoscale-config.asg_scale_up
  asg_scale_down = module.autoscale-config.asg_scale_down
}

module "securitygroup-config" {
  source = "../modules/securitygroup-config"
  asg_name = "robertom-terraform-sg-example"
}

module "loadbalancer-config" {
  source = "../modules/loadbalancer-config"
  asg_id = module.securitygroup-config.asg_id
}

module "iam-role-policy-config" {
  source        = "../modules/iam-role-policy-config"
  role_name     = "robertom-instance-role"
  policy_name   = "robertom-ec2-full-access"
}
