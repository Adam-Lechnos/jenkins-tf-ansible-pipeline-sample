output "arn" {
  description = "ARN of SNS topic"
  value       = element(concat(aws_sns_topic.sns_topic.*.arn, [""]), 0)
}
