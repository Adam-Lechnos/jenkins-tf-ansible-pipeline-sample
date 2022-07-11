variable "instance_count" {
  description = "Number of instances to be attached"
  type        = number
  default     = 1
}

variable "target_group_arn" {
  description = "The ARN of the target group with which to register targets"
  type        = string
}

variable "target_ids" {
  description = "The ID's of the target. This is the Instance ID for an instance, or the container ID for an ECS container. If the target type is ip, specify an IP address. If the target type is lambda, specify the arn of lambda."
  type        = list(string)
}

variable "port" {
  description = "The port on which targets receive traffic."
  type        = string
  default     = null
}

variable "availability_zone" {
  description = "The Availability Zone where the IP address of the target is to be registered."
  type        = string
  default     = null
}
