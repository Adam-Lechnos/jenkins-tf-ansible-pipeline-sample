variable "create_sns_topic_subscription" {
  description = "Whether to create the SNS topic subscription"
  type        = bool
  default     = true
}

variable "sns_topic_arn" {
  description = "The ARN of the SNS topic to subscribe to"
  type        = string
  default     = null
}

variable "protocol" {
  description = "The protocol to use. The possible values for this are: sqs, sms, lambda, application. (http or https are partially supported) (email is an option but is unsupported)."
  type        = string
  default     = null
}

variable "endpoint" {
  description = "The endpoint to send data to, the contents will vary with the protocol."
  type        = string
  default     = null
}

variable "endpoint_auto_confirms" {
  description = "Boolean indicating whether the end point is capable of auto confirming subscription e.g., PagerDuty (default is false)"
  type        = bool
  default     = false
}

variable "confirmation_timeout_in_minutes" {
  description = "Integer indicating number of minutes to wait in retying mode for fetching subscription arn before marking it as failure. Only applicable for http and https protocols (default is 1 minute)."
  type        = number
  default     = 1
}

variable "raw_message_delivery" {
  description = "Boolean indicating whether or not to enable raw message delivery (the original message is directly passed, not wrapped in JSON with the original message in the message property) (default is false)."
  type        = bool
  default     = false
}

variable "filter_policy" {
  description = "JSON String with the filter policy that will be used in the subscription to filter messages seen by the target resource."
  type        = string
  default     = null
}

variable "delivery_policy" {
  description = "JSON String with the delivery policy (retries, backoff, etc.) that will be used in the subscription - this only applies to HTTP/S subscriptions."
  type        = string
  default     = null
}