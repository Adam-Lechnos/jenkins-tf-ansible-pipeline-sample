data "aws_instances" "get_private_ips" {
  instance_tags = var.instance_tags
  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
  instance_state_names = var.instance_state_names
}