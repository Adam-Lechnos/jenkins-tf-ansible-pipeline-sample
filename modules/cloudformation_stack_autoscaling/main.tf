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

resource "aws_cloudformation_stack" "default" {
  name               = var.cf_stack_name
  tags               = var.cf_tags
   timeout_in_minutes = var.timeout_in_minutes
   template_body = <<EOF
 {
   "Conditions": {
     "UsePlacementGroup": {"Fn::Not": [{"Fn::Equals": ["", ${jsonencode(var.placement_group)}]}]},
     "UseServiceLinkedRoleARN": {"Fn::Not": [{"Fn::Equals": ["", ${jsonencode(var.service_linked_role_arn)}]}]}
   },  
   "Resources": {
     "AutoScalingGroup": {
       "Type": "AWS::AutoScaling::AutoScalingGroup",
       "Properties": {
         "AutoScalingGroupName": "${var.autoscaling_group_name}",
         "AvailabilityZones": ${jsonencode(var.availability_zones)},
         "Cooldown": "${var.default_cooldown}",
         "HealthCheckType": "${var.health_check_type}",
         "HealthCheckGracePeriod": "${var.health_check_grace_period}",
         "LaunchTemplate": {
           "LaunchTemplateId" : "${aws_launch_template.default.id}",
           "Version" : "${aws_launch_template.default.latest_version}"
         },
         "LifecycleHookSpecificationList" : ${jsonencode(var.lifecycle_hook_specification)},
         "LoadBalancerNames" : ${jsonencode(var.loadbalancer_names)},
         "DesiredCapacity": "${var.desired_capacity}",
         "MaxSize": "${var.max_size}",
         "MetricsCollection": ${jsonencode(var.metrics_collections)},
         "MinSize": "${var.min_size}",
         "NotificationConfigurations": ${jsonencode(var.notification_configurations)},
         "PlacementGroup": {
           "Fn::If" : [
             "UsePlacementGroup",
             ${jsonencode(var.placement_group)},
             {"Ref" : "AWS::NoValue"}
           ]
         },
         "ServiceLinkedRoleARN": {
           "Fn::If" : [
             "UseServiceLinkedRoleARN",
             ${jsonencode(var.service_linked_role_arn)},
             {"Ref" : "AWS::NoValue"}
           ]
         },
         "TargetGroupARNs": ${jsonencode(var.target_group_arns)},
         "TerminationPolicies": ${jsonencode(var.termination_policies)},
         "Tags": ${jsonencode(var.asg_tags)},
         "VPCZoneIdentifier": ${jsonencode(var.subnet_ids)}
       },
       "UpdatePolicy": {
         "AutoScalingRollingUpdate": ${jsonencode(var.rolling_update)},
         "AutoScalingReplacingUpdate": ${jsonencode(var.replacing_update)}
       }
     }
   },
   "Outputs": {
     "AsgName": {
       "Description": "The name of the auto scaling group",
       "Value": {
         "Ref": "AutoScalingGroup"
       }
     }
   }
 }
 EOF
 }