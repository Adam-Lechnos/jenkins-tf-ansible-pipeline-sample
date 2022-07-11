resource "aws_lb_target_group_attachment" "this" {
  count             = var.instance_count
  target_group_arn  = var.target_group_arn
  target_id         = element(var.target_ids, count.index)
  port              = var.port
  availability_zone = var.availability_zone
}
