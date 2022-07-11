locals {
  vmss_tags = merge(
    {
      "fds:build_access_set" = var.build_access_set
      "fds:HostRole"         = var.scaleset_prefix
      "fds:image_name"       = var.image_name
      "fds:image_version"    = var.image_version
      "fds:workspace_name"   = var.param_workspace_name
      "fds:asgprefix"        = var.scaleset_prefix
      "fds:git_repo"         = var.git_repo
      "fds:cloud_resource"   = "auto scaling group"
    },
    var.vmss_tags
  )
 
  stack_tag = "ASG---build--${var.image_name_trimmed}---ws--${var.param_workspace_name_trimmed}"
  tags_asg_format = null_resource.tags_as_list_of_maps.*.triggers
  sg_ingress = flatten([
      for ingress in var.user_defined_sg_ingress : [{
        from_port   = ingress.from_port
        to_port     = ingress.to_port
        protocol    = ingress.protocol
        self        = ingress.self
        cidr_blocks = ["10.0.0.0/8", "164.55.0.0/16", "172.16.0.0/12"]
      }]
    ])

}

resource "null_resource" "tags_as_list_of_maps" {
  count = length(keys(local.vmss_tags))

  triggers = {
    "Key"               = keys(local.vmss_tags)[count.index]
    "Value"             = values(local.vmss_tags)[count.index]
    "PropagateAtLaunch" = "true"
  }
}