output "name" {
  value = aws_elb.new_elb.name
}

output "dns_name" {
  value = aws_elb.new_elb.dns_name
}

output "zone_id" {
  value = aws_elb.new_elb.zone_id
}
