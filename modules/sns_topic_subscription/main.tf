resource "aws_sns_topic_subscription" "sns_topic_sub" {
  count = var.create_sns_topic_subscription ? 1 : 0

  topic_arn                       = var.sns_topic_arn
  protocol                        = var.protocol
  endpoint                        = var.endpoint
  endpoint_auto_confirms          = var.endpoint_auto_confirms
  confirmation_timeout_in_minutes = var.confirmation_timeout_in_minutes
  raw_message_delivery            = var.raw_message_delivery
  filter_policy                   = var.filter_policy
  delivery_policy                 = var.delivery_policy
}