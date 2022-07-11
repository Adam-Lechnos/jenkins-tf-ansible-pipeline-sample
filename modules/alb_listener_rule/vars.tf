
variable "listener_arn" {
  description = "The ARN of the listener to which to attach the rule."
  type        = string
}

variable "priority" {
  description = "The priority for the rule between 1 and 50000. Leaving it unset will automatically set the rule with next available priority after currently existing highest rule. A listener can't have multiple rules with the same priority."
  type        = string
  default     = null
}

variable "action" {
  description = "Action Blocks"
  type        = list(map(string))
  default     = []
}

variable "redirect" {
  description = "Redirect Blocks"
  type        = list(map(string))
  default     = []
}

variable "fixed_response" {
  description = "Fixed-response Blocks"
  type        = list(map(string))
  default     = []
}

variable "authenticate_cognito" {
  description = "Authenticate cognito Blocks"
  //type        = list(map(string))
  default = []
}

variable "authenticate_oidc" {
  description = "Authenticate OIDC Blocks"
  //type        = list(map(string))
  default = []
}

variable "condition" {
  description = "Condition Blocks"
  //type        = list(map(string))
  default = []
}