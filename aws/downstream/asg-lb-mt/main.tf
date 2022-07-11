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

data "aws_ami" "centos_ami" {
  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "tag:IMAGE_VERSION"
    values = ["${var.image_name}-${var.image_version}"]
  }

  most_recent = true
  owners      = var.ami_owner_list
}

data "aws_vpcs" "platform_private_vpc" {
  filter {
    name   = "tag:Name"
    values = var.private_vpc
  }
}

//data "aws_subnet" "selected" {
  //count             = length(var.vmss_zones) == 1 ? 1 : 0
  //availability_zone = var.vmss_zones[0]
  //filter {
    //name   = "tag:immutable_metadata"
    //values = var.subnet_tag_name
  //}
//}

data "aws_subnet_ids" "private_compute" {
  count  = length(var.pg_prefix)
  vpc_id = sort(data.aws_vpcs.platform_private_vpc.ids)[0]
  filter {
    name   = "tag:Name"
    values = var.pg_prefix
  }
}

module "create_security_group" {
  //for_each    = var.target_groups
  source      = "../../../modules/security_group"
  //name        = "${var.scaleset_prefix}-secgroup"
  name        = var.scaleset_prefix
  vpc_id      = sort(data.aws_vpcs.platform_private_vpc.ids)[0]
  description = var.sg_description
  ingress     = local.sg_ingress
  egress      = var.sg_egress
  tags = merge(
    var.sg_tags,
    local.vmss_tags,
    {
      "Name" = "${var.scaleset_prefix}-secgroup"
      "fds:cloudformation:stack-name" = local.stack_tag
    }
  )
}

module "create_network_lb" {
  source             = "../../../modules/lb"
  for_each           = var.load_balancers
  name               = each.key
  load_balancer_type = "network"
  internal           = true
  //subnets            = length(var.vmss_zones) == 1 ? list(data.aws_subnet.selected[0].id) : tolist(data.aws_subnet_ids.private_compute[0].ids)
  subnets            = tolist(data.aws_subnet_ids.private_compute[0].ids)
  vpc_id             = sort(data.aws_vpcs.platform_private_vpc.ids)[0]
  target_groups      = each.value.target_groups
  http_tcp_listeners = each.value.http_tcp_listeners
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = templatefile("../../cloudinit/install_runtime.sh", { runtime_data = var.runtime_data, account_name = data.aws_ssm_parameter.account_name.value, asg_name = var.scaleset_prefix, username = var.username, alerting_thresholds = var.alerting_thresholds })
  }
}

module "create_autoscaling_group" {
  //for_each                  = var.target_groups
  source                    = "../../../modules/cloudformation_stack_autoscaling"
  template_name             = var.scaleset_prefix
  //cf_stack_name             = "stack"
  //cf_tags                   = local.vmss_tags
  autoscaling_group_name    = "asg"
  instance_type             = var.vm_type
  block_device_mappings     = var.block_device_mappings
  image_id                  = data.aws_ami.centos_ami.image_id
  vpc_security_group_ids    = concat(data.aws_security_groups.security_group_ids.ids, [module.create_security_group.id])
  user_data_base64          = data.template_cloudinit_config.config.rendered
  iam_instance_profile_name = var.iam_instance_profile_name
  volume_tags               = merge(local.vmss_tags,{"fds:cloudformation:stack-name"=local.stack_tag})
  ec2_tags                  = var.vmss_tags
  //subnet_ids              = length(var.vmss_zones) == 1 ? list(data.aws_subnet.selected[0].id) : tolist(data.aws_subnet_ids.private_compute[0].ids)
  subnet_ids                = tolist(data.aws_subnet_ids.private_compute[0].ids)
  max_size                  = var.vm_count != 0 ? var.vm_count : var.max_size
  min_size                  = var.vm_count != 0 ? var.vm_count : var.min_size
  desired_capacity          = var.vm_count != 0 ? var.vm_count : var.desired_capacity
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  target_group_arns         = flatten(values(module.create_network_lb)[*].target_group_arns)
  //metrics_collections       = var.metrics_collections
  //placement_group           = var.proximity_placement_group_name
  rolling_update            = var.rolling_upgrade_policy
  min_healthy_percentage    = var.min_healthy_percentage
  instance_warmup           = var.instance_warmup
  heartbeat_timeout         = var.heartbeat_timeout
  suspended_processes       = var.suspended_processes
//   asg_tags                  = [for k, v in local.vmss_tags: {
//     key = "${k}"
//     value = "${v}"
//     propagate_at_launch = true
//   }
//   ]
// }

module "create_route53" {
  for_each               = var.load_balancers
  source                 = "../../../modules/route53_alias"
  parent_zone_name       = local.parent_zone_name
  private_zone           = var.private_zone
  alias_name             = each.key
  target_dns_name        = module.create_network_lb[each.key].lb_dns_name
  target_zone_id         = module.create_network_lb[each.key].lb_zone_id
  evaluate_target_health = var.evaluate_target_health
}