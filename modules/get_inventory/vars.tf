variable "instance_state_names" {
  description = "A list of instance states that should be applicable to the desired instances. The permitted values are: pending, running, shutting-down, stopped, stopping, terminated"
  type        = list(string)
  default     = ["running"]
}

variable "instance_tags" {
  description = "A mapping of tags, each pair of which must exactly match a pair on desired instances."
  type        = map(string)
  default     = {}
}

variable "filter" {
  description = "One or more name/value pairs to use as filters. "
  //type        = list(map(string))
  default = []
}