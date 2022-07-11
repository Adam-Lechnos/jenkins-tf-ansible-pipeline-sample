output "ids" {
  value = data.aws_instances.get_private_ips.ids
}

output "private_ips" {
  value = data.aws_instances.get_private_ips.private_ips
}