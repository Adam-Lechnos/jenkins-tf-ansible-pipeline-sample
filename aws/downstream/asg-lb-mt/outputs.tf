/*output "target_group_arns" {
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
  value       = flatten(values(module.create_network_lb)[*].target_group_arns)
}*/

output "security_group_ids" {
description = "secuirty group ingress rules"
value       = local.sg_ingress
}