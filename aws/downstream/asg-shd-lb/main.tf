terraform {
  backend "s3" {}
}

data "aws_ssm_parameter" "account_name" {
  name = var.ssm_account_name_paramter
}

data "aws_security_groups" "security_group_ids" {
  filter {
    name   = "group-name"
    values = var.sg_subs
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

/*module "create_security_group" {
  source      = "../../../modules/security_group"
  name        = var.scaleset_prefix
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
}*/

/*module "create_network_lb" {
  source             = "../../../modules/lb"
  create_lb          = true
  name               = var.scaleset_prefix
  load_balancer_type = "network"
  internal           = true
  //subnets            = length(var.vmss_zones) == 1 ? list(data.aws_subnet.selected[0].id) : tolist(data.aws_subnet_ids.private_compute[0].ids)
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
}*/

data "aws_lb_target_group" "shared" {
  count = length(var.lb_tg_name)
  name = var.lb_tg_name[count.index]
}



/*data "aws_lb_target_group" "shared" {
  name = var.lb_tg_name
}*/



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
  source                    = "../../../modules/autoscaling_refresh_strategy"
  template_name            = var.scaleset_prefix
  //cf_stack_name             = local.stack_tag
  //cf_tags                   = local.vmss_tags
  autoscaling_group_name    = var.scaleset_prefix
  instance_type             = var.vm_type
  block_device_mappings     = var.block_device_mappings
  image_id                  = data.aws_ami.centos_ami.image_id
  vpc_security_group_ids    = data.aws_security_groups.security_group_ids.ids
  //vpc_security_group_ids    = concat(data.aws_security_groups.security_group_ids.ids, data.aws_security_groups.security_group_target_ids.ids)
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
  target_group_arns         = data.aws_lb_target_group.shared[*].arn
  //target_group_arns         = module.create_network_lb.target_group_arns
  //metrics_collections       = var.metrics_collections
  //placement_group           = var.proximity_placement_group_name
  rolling_update            = var.rolling_upgrade_policy
  min_healthy_percentage    = var.min_healthy_percentage
  instance_warmup           = var.instance_warmup
  heartbeat_timeout         = var.heartbeat_timeout
  suspended_processes       = var.suspended_processes
  asg_tags                  = [for k, v in local.vmss_tags: {
    key = "${k}"
    value = "${v}"
    propagate_at_launch = true
  }
  ]
}

/*module "create_route53" {
  source                 = "../../../modules/route53_alias"
  parent_zone_name       = local.parent_zone_name
  private_zone           = var.private_zone
  alias_name             = var.scaleset_prefix
  target_dns_name        = module.create_network_lb.lb_dns_name
  target_zone_id         = module.create_network_lb.lb_zone_id
  evaluate_target_health = var.evaluate_target_health
}*/