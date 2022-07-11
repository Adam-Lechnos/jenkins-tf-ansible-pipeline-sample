terraform {
  backend "s3" {}
}

module "create_security_group" {
  source      = "../../../modules/security_group"
  for_each    = var.sg_rules
  name        = each.key
  vpc_id      = sort(data.aws_vpcs.platform_private_vpc.ids)[0]
  description = var.param_workspace_name
  ingress     = each.value.sg_ingress
  egress      = var.sg_egress
  tags        = {
      "fds:build_access_set" = var.build_access_set
      "fds:image_name"       = var.image_name
      "fds:image_version"    = var.image_version
      "fds:workspace_name"   = var.param_workspace_name
      "fds:git_repo"         = var.git_repo
      "fds:cloud_resource"   = "security group"
    }
}

data "aws_ssm_parameter" "account_name" {
  name = var.ssm_account_name_paramter
}

/*data "aws_security_groups" "security_group_ids" {
  filter {
    name   = "group-name"
    values = var.sg_name
  }
}*/

data "aws_vpcs" "platform_private_vpc" {
  filter {
    name   = "tag:Name"
    values = var.private_vpc
  }
}

data "aws_subnet_ids" "private_compute" {
  //count  = length(var.zones) > 1 ? 1 : 0
  count = 1
  vpc_id = sort(data.aws_vpcs.platform_private_vpc.ids)[0]
  filter {
    name   = "tag:immutable_metadata"
    values = var.subnet_tag_name
  }
}