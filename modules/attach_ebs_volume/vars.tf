variable "device_name" {
  description = "The device name to expose to the instance"
  type        = "string"
  default     = "/dev/sdh"
}

variable "instance_id" {
  description = "ID of the Instance to attach to"
  type        = "list"
}

variable "ebs_volume_id" {
  description = "ID of the Volume to be attached"
  type        = "list"
}

variable "skip_destroy" {
  description = "Set to true if you want to force the volume to detach. Useful if previous attempts failed, but use this option only as a last resort, as this can result in data loss."
  type        = bool
  default     = true
}

variable "force_detach" {
  description = "Set this to true if you do not wish to detach the volume from the instance to which it is attached at destroy time, and instead just remove the attachment from Terraform state. This is useful when destroying an instance which has volumes created by some other means attached."
  type        = bool
  default     = true
}