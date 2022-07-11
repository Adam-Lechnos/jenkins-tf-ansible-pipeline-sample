resource "aws_autoscaling_notification" "asg_notifications" {
  count         = var.create_autoscaling_notification ? 1 : 0
  group_names   = var.group_names
  notifications = var.notifications
  topic_arn     = var.topic_arn
}


