variable "create_sg" {
  description = "Enable security group creation."
  type        = bool
  default     = true
}

variable "name" {
  description = "The name of the security group. If omitted, Terraform will assign a random, unique name"
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null
}

variable "description" {
  description = "The security group description."
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "revoke_rules_on_delete" {
  description = "Instruct Terraform to revoke all of the Security Groups attached ingress and egress rules before deleting the rule itself. "
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "ingress" {
  description = "A list of Ingress blocks"
  type        = any
  default     = []
}

variable "egress" {
  description = "A list of Egress blocks"
  default     = []
}
