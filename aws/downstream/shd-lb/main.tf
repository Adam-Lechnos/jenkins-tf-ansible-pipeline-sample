terraform {
  backend "s3" {}
}

data "aws_ssm_parameter" "account_name" {
  name = var.ssm_account_name_paramter
}

data "aws_security_groups" "security_group_ids" {
  filter {
    name   = "group-name"
    values = var.sg_name
  }
}

data "aws_vpcs" "platform_private_vpc" {
  filter {
    name   = "tag:Name"
    values = var.private_vpc
  }
}

data "aws_subnet_ids" "private_compute" {
  count  = length(var.pg_prefix)
  vpc_id = sort(data.aws_vpcs.platform_private_vpc.ids)[0]
  filter {
    name   = "tag:Name"
    values = var.pg_prefix
  }
}

module "create_security_group" {
  source      = "../../../modules/security_group"
  name        = "shd--${var.lb_name}"
  vpc_id      = sort(data.aws_vpcs.platform_private_vpc.ids)[0]
  description = var.sg_description
  ingress     = local.sg_ingress
  egress      = var.sg_egress
  tags = merge(
    var.sg_tags,
    local.vmss_tags,
    {
      "Name" = var.scaleset_prefix
      "fds:cloudformation:stack-name" = local.stack_tag
    }
  )
}

module "create_network_lb" {
  source             = "../../../modules/lb"
  create_lb          = true
  name               = "shd--${var.lb_name}"
  load_balancer_type = "network"
  internal           = true
  subnets            = tolist(data.aws_subnet_ids.private_compute[0].ids)
  vpc_id             = sort(data.aws_vpcs.platform_private_vpc.ids)[0]
  target_groups      = var.target_groups
  http_tcp_listeners = var.http_tcp_listeners
  tags = merge(
    var.elb_tags,
    local.vmss_tags,
    {
      "fds:cloudformation:stack-name" = local.stack_tag
    }
  )
}

module "create_route53" {
  source                 = "../../../modules/route53_alias"
  parent_zone_name       = local.parent_zone_name
  private_zone           = var.private_zone
  alias_name             = var.lb_name
  target_dns_name        = module.create_network_lb.lb_dns_name
  target_zone_id         = module.create_network_lb.lb_zone_id
  evaluate_target_health = var.evaluate_target_health
}