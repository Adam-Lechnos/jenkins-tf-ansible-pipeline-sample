resource "aws_launch_template" "default" {
  name = var.template_name
  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings
    content {
      device_name  = lookup(block_device_mappings.value, "device_name", null)
      no_device    = lookup(block_device_mappings.value, "no_device", null)
      virtual_name = lookup(block_device_mappings.value, "virtual_name", null)

      dynamic "ebs" {
        for_each = flatten(tolist([lookup(block_device_mappings.value, "ebs", [])]))
        content {
          delete_on_termination = lookup(ebs.value, "delete_on_termination", null)
          encrypted             = lookup(ebs.value, "encrypted", null)
          kms_key_id            = lookup(ebs.value, "kms_key_id", null)
          snapshot_id           = lookup(ebs.value, "snapshot_id", null)
          volume_size           = lookup(ebs.value, "volume_size", null)
          volume_type           = lookup(ebs.value, "volume_type", null)
          throughput            = lookup(ebs.value, "throughput", null)
          iops                  = lookup(ebs.value, "iops", null)
        }
      }
    }
  }

  dynamic "credit_specification" {
    for_each = var.credit_specification != null ? [var.credit_specification] : []
    content {
      cpu_credits = lookup(credit_specification.value, "cpu_credits", null)
    }
  }

  disable_api_termination = var.disable_api_termination
  ebs_optimized           = var.ebs_optimized

  dynamic "elastic_gpu_specifications" {
    for_each = var.elastic_gpu_specifications != null ? [var.elastic_gpu_specifications] : []
    content {
      type = lookup(elastic_gpu_specifications.value, "type", null)
    }
  }

  image_id                             = var.image_id
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior

  dynamic "instance_market_options" {
    for_each = var.instance_market_options != null ? [var.instance_market_options] : []
    content {
      market_type = lookup(instance_market_options.value, "market_type", null)

      dynamic "spot_options" {
        for_each = flatten(tolist(lookup(instance_market_options.value, "spot_options", [])))
        content {
          block_duration_minutes         = lookup(spot_options.value, "block_duration_minutes", null)
          instance_interruption_behavior = lookup(spot_options.value, "instance_interruption_behavior", null)
          max_price                      = lookup(spot_options.value, "max_price", null)
          spot_instance_type             = lookup(spot_options.value, "spot_instance_type", null)
          valid_until                    = lookup(spot_options.value, "valid_until", null)
        }
      }
    }
  }

  instance_type = var.instance_type
  key_name      = var.key_name

  dynamic "placement" {
    for_each = var.placement != null ? [var.placement] : []
    content {
      affinity          = lookup(placement.value, "affinity", null)
      availability_zone = lookup(placement.value, "availability_zone", null)
      group_name        = lookup(placement.value, "group_name", null)
      host_id           = lookup(placement.value, "host_id", null)
      tenancy           = lookup(placement.value, "tenancy", null)
    }
  }

  vpc_security_group_ids = var.vpc_security_group_ids
  user_data              = var.user_data_base64

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  monitoring {
    enabled = var.enable_monitoring
  }

  # https://github.com/terraform-providers/terraform-provider-aws/issues/4570
  dynamic "network_interfaces" {
    for_each = var.network_interfaces
    content {
      description                 = lookup(network_interfaces.value, "description", null)
      device_index                = lookup(network_interfaces.value, "device_index")
      associate_public_ip_address = lookup(network_interfaces.value, "associate_public_ip_address", false)
      delete_on_termination       = lookup(network_interfaces.value, "delete_on_termination", true)
      security_groups             = lookup(network_interfaces.value, "security_groups", [])
      ipv6_addresses              = lookup(network_interfaces.value, "ipv6_addresses", [])
      ipv6_address_count          = lookup(network_interfaces.value, "ipv6_address_count", 0)
      network_interface_id        = lookup(network_interfaces.value, "network_interface_id", "")
      private_ip_address          = lookup(network_interfaces.value, "private_ip_address", "")
      ipv4_addresses              = lookup(network_interfaces.value, "ipv4_addresses", [])
      ipv4_address_count          = lookup(network_interfaces.value, "ipv4_address_count", 0)
      subnet_id                   = lookup(network_interfaces.value, "subnet_id", "")
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags          = var.volume_tags
  }

  tag_specifications {
    resource_type = "instance"
    tags          = var.ec2_tags
  }

  tags = var.volume_tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "random_uuid" "asg" {
}

resource "aws_autoscaling_group" "default" {
  name                      = var.autoscaling_group_name
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  default_cooldown          = var.default_cooldown
  suspended_processes       = var.suspended_processes
  metrics_granularity       = var.metrics_granularity
  enabled_metrics           = var.metrics_collections 
  placement_group           = var.placement_group
  target_group_arns         = var.target_group_arns
  vpc_zone_identifier       = var.subnet_ids
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  min_size                  = var.min_size
  termination_policies      = var.termination_policies

  launch_template {
    id      = aws_launch_template.default.id
    version = "$Latest"
  }

  tags = concat(
    [
      {
        "key"                 = "UUID"
        "value"               = "${random_uuid.asg.result}"
        "propagate_at_launch" = true      
      },
    ],
    var.asg_tags
  )

  instance_refresh {
    strategy = var.strategy
    preferences {
      min_healthy_percentage = var.min_healthy_percentage
      instance_warmup        = var.instance_warmup
    }
    triggers = ["tag"]
  }
}

// resource "aws_autoscaling_lifecycle_hook" "default" {
//   name                   = "Default-WaitPeriodTrafficBlock"
//   autoscaling_group_name = aws_autoscaling_group.default.name
//   default_result         = "CONTINUE"
//   heartbeat_timeout      = var.heartbeat_timeout
//   lifecycle_transition   = "autoscaling:EC2_INSTANCE_LAUNCHING"
// }