resource "aws_security_group" "allow_tls" {
  count                  = var.create_sg ? 1 : 0
  name                   = var.name
  name_prefix            = var.name_prefix
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

  dynamic "ingress" {
    for_each = var.ingress
    content {
      cidr_blocks      = lookup(ingress.value, "cidr_blocks", [])
      ipv6_cidr_blocks = lookup(ingress.value, "ipv6_cidr_blocks", null)
      prefix_list_ids  = lookup(ingress.value, "prefix_list_ids", [])
      from_port        = ingress.value.from_port
      protocol         = ingress.value.protocol
      security_groups  = lookup(ingress.value, "security_groups", [])
      self             = lookup(ingress.value, "self", false)
      to_port          = ingress.value.to_port
      description      = lookup(ingress.value, "description", "")
    }
  }

  dynamic "egress" {
    for_each = var.egress
    content {
      cidr_blocks      = lookup(egress.value, "cidr_blocks", [])
      ipv6_cidr_blocks = lookup(egress.value, "ipv6_cidr_blocks", null)
      prefix_list_ids  = lookup(egress.value, "prefix_list_ids", [])
      from_port        = egress.value.from_port
      protocol         = egress.value.protocol
      security_groups  = lookup(egress.value, "security_groups", [])
      self             = lookup(egress.value, "self", false)
      to_port          = egress.value.to_port
      description      = lookup(egress.value, "description", "")
    }
  }

  tags = merge(
    {
      "Name" = format("%s", coalesce(var.name, var.name_prefix, "fds_default_sg"))
    },
    var.tags,
  )
}
