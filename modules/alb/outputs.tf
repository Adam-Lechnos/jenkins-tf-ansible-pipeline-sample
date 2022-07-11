output "http_tcp_listener_arn" {
  value = aws_lb_listener.frontend_http_tcp[*].arn
}

output "target_group_arn" {
  value = aws_lb_target_group.main[*].arn
}

output "dns_name" {
  value = aws_lb.application[0].dns_name
}

output "zone_id" {
  value = aws_lb.application[0].zone_id
}
