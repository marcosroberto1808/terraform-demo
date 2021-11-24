module "role" {
  # Check releases for updates in this module
  source = "git@github.azc.ext.hp.com:runway/terraform-aws-iam//modules/iam-role?ref=v4.0.9"

  role_name = var.role_name
  role_path = "/"

  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonESFullAccess",
    module.create_policy.policy_arn,
  ]

  assume_role_policy = file("${path.module}/assume-role-policy.json")

}

module "create_policy" {
  # Check releases for updates in this module
  source = "git@github.azc.ext.hp.com:runway/terraform-aws-iam//modules/iam-policy?ref=v4.0.9"

  policy_name     = var.policy_name
  policy_path = "/"
  policy_document = file("${path.module}/policy.json")

}
