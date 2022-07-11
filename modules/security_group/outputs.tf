output "name" {
  value = join(",", aws_security_group.allow_tls.*.name)
}

output "id" {
  value = join(",", aws_security_group.allow_tls.*.id)
}
