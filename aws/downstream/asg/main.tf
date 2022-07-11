terraform {
  backend "s3" {}
}

data "aws_ssm_parameter" "account_name" {
  name = var.ssm_account_name_parameter
}

data "aws_ssm_parameter" "account_environment" {
  name = var.ssm_account_environment_parameter
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
  create_sg   = length(var.user_defined_sg_ingress) > 0 ? true : false
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
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = templatefile("../../cloudinit/install_runtime.sh", { runtime_data = var.runtime_data, proximity_placement_group_name = var.proximity_placement_group_name, account_name = data.aws_ssm_parameter.account_name.value, asg_name = var.scaleset_prefix, username = var.username, alerting_thresholds = var.alerting_thresholds })
  }
}

module "create_autoscaling_group" {
  //source                    = "../../../modules/cloudformation_stack_autoscaling"
  source                    = "../../../modules/autoscaling_refresh_strategy"
  template_name             = var.scaleset_prefix
  //cf_stack_name             = local.stack_tag
  //cf_tags                   = local.vmss_tags
  autoscaling_group_name    = var.scaleset_prefix
  instance_type             = var.vm_type
  block_device_mappings     = var.block_device_mappings
  image_id                  = data.aws_ami.centos_ami.image_id
  vpc_security_group_ids    = concat(data.aws_security_groups.security_group_ids.ids, [module.create_security_group.id])
  user_data_base64          = data.template_cloudinit_config.config.rendered
  iam_instance_profile_name = var.iam_instance_profile_name
  volume_tags               = local.vmss_tags
  ec2_tags                  = var.vmss_tags
  subnet_ids                = tolist(data.aws_subnet_ids.private_compute[0].ids)
  max_size                  = var.vm_count != 0 ? var.vm_count : var.max_size
  min_size                  = var.vm_count != 0 ? var.vm_count : var.min_size
  desired_capacity          = var.vm_count != 0 ? var.vm_count : var.desired_capacity
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  //rolling_update            = var.rolling_upgrade_policy
  min_healthy_percentage    = var.min_healthy_percentage
  instance_warmup           = var.instance_warmup
  heartbeat_timeout         = var.heartbeat_timeout
  suspended_processes       = var.suspended_processes
  //asg_tags                  = local.tags_asg_format
  asg_tags                  = [for k, v in local.vmss_tags: {
    key = "${k}"
    value = "${v}"
    propagate_at_launch = true
  }
  ]
}
