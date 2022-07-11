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

data "aws_subnet" "a" {
  count             = length(var.zones) == 1 ? 1 : 0
  availability_zone = var.zones[0]
  filter {
    name   = "tag:Name"
    values = values = ["sbu-content-dev-compute-a-1"]
  }
}

data "aws_subnet" "b" {
  count             = length(var.zones) == 1 ? 1 : 0
  availability_zone = var.zones[0]
  filter {
    name   = "tag:Name"
    values = values = ["sbu-content-dev-compute-b-1"]
  }
}

data "aws_subnet" "c" {
  count             = length(var.zones) == 1 ? 1 : 0
  availability_zone = var.zones[0]
  filter {
    name   = "tag:Name"
    values = values = ["sbu-content-dev-compute-c-1"]
  }
}

data "aws_subnet_ids" "private_compute" {
  count  = length(var.zones) > 1 ? 1 : 0
  vpc_id = sort(data.aws_vpcs.platform_private_vpc.ids)[0]
  filter {
    name   = "tag:immutable_metadata"
    values = var.subnet_tag_name
  }
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = templatefile("../../cloudinit/install_runtime.sh", { runtime_data = var.runtime_data, account_name = join(".", slice(split(".", data.aws_ssm_parameter.account_name.value), 0, length(split(".", data.aws_ssm_parameter.account_name.value)) - 1)) })
  }
}

module "create_ec2_a" {
  source                 = "../../../modules/ec2"
  ami                    = data.aws_ami.centos_ami.image_id
  instance_count         = var.vm_count
  instance_type          = var.vm_size
  subnet_ids             = length(var.zones) == 1 ? list(data.aws_subnet.selected[0].id) : tolist(data.aws_subnet_ids.private_compute[0].ids)
  vpc_security_group_ids = data.aws_security_groups.security_group_ids.ids
  user_data_base64       = data.template_cloudinit_config.config.rendered
  root_block_device      = var.root_block_device
  placement_group        = var.proximity_placement_group_name
  tags                   = var.tags
}
