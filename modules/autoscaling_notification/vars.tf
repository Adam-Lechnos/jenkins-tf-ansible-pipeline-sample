variable "create_autoscaling_notification" {
  description = "Whether to create the autoscaling notification"
  type        = bool
  default     = true
}

variable "group_names" {
  description = "A list of AutoScaling Group Names"
  type        = list(string)
}

variable "notifications" {
  description = "A list of Notification Types that trigger notifications."
  type        = list(any)
}

variable "topic_arn" {
  description = "The Topic ARN for notifications to be sent through"
  type        = string
}