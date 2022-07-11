output "id" {
  description = "ARN of SNS topic subscription"
  value       = element(concat(aws_sns_topic_subscription.sns_topic_sub.*.id, [""]), 0)
}
