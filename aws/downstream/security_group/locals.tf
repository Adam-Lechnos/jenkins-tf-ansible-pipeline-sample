/*locals {
  sg_ingress = flatten([
      for sg_rules in var.sg_rules : [{
        description = sg_rules.description
        protocol    = sg_rules.protocol
        from_port   = sg_rules.from_port
        to_port     = sg_rules.to_port
        self        = sg_rules.self
        cidr_blocks = [sg_rules.cidr_blocks]
      }]
    ])
}*/
