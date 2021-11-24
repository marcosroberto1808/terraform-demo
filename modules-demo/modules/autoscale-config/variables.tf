variable "lc_settings" {
  type = object({
    name    = string
    image_id = string
    instance_type = string
    key_name = string
    asg_max_size = number
    asg_min_size = number
    asg_id = string
    lb_tg_arn = string
  })
  default = {
    name = "robertom-terraform-lc-example"
    image_id = "ami-0c2d06d50ce30b442"
    instance_type = "t2.micro"
    key_name= "robertom-terraform-test"
    asg_max_size = 2
    asg_min_size = 1
    asg_id = ""
    lb_tg_arn = ""
  }
  description = "Launch Configuration settings data."
}