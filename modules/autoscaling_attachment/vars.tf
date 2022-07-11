variable "autoscaling_group_name" {
  description = "Name of ASG to associate with the ELB."
  type        = string
}

variable "elb" {
  description = "The name of the ELB."
  type        = string
  default     = null
}

variable "alb_target_group_arn" {
  description = "The ARN of an ALB Target Group."
  type        = string
  default     = null
}