variable "runtime_data" {
  description = "Dynamic data to be used in cloudinit script"
  type        = string
  default     = ""
}

variable "location" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ssm_account_name_paramter" {
  description = "SSM account name parameter"
  type        = string
  default     = "/fdscloud/account_name"
}

variable "image_version" {
  description = "AMI Image Version"
  type        = string
  default     = "latest"
}

variable "ami_owner_list" {
  description = "AMI Owner's list"
  type        = list(string)
  default     = ["self","053821600536"]
}

variable "image_name" {
  description = "AMI Image Name"
  type        = string
  default     = "FDSCzmc_image"
}

variable "private_vpc" {
  description = "Default Platform's private vpc regex"
  type        = list(string)
  default     = ["sbu-content-*-*-*-vpc-1"]
}

variable "zones" {
  description = "availability zone"
  type        = list(string)
  default     = ["us-east-1c"]
}

variable "subnet_tag_name" {
  description = "Default Platform's subnet name regex"
  type        = list(string)
  default     = ["{\"purpose\":\"compute\"}"]
}

variable "sg_name" {
  description = "Security group name"
  type        = list(string)
  default     = ["fds-default-compute-secgroup", "fds-default-additional-secgroup"]
}

variable "vm_count" {
  description = "Number of instances to launch"
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "The type of instance to start"
  type        = string
  default     = "c5n.large"
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance"
  type        = list(map(string))
  default = [{
    volume_size           = "30"
    volume_type           = "gp2"
    encrypted             = "false"
    delete_on_termination = "true"
  }]
}

variable "proximity_placement_group_name" {
  description = "The Placement Group to start the instance in"
  type        = string
  default     = "quotes_ppg"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default = {
    "fds:BusinessUnit"     = "Content Engineering"
    "fds:InfraEnvironment" = "dev"
    "fds:InfraOwner"       = "quotes_engineer@factset.com"
    "fds:Provisioner"      = "terraform"
    "fds:TaggingVersion"   = "1.0"
    "fds:HostRole"         = "test"
    "fds:HostNum"          = "01"
  }
}

variable "build_access_set" {
  description = "Admin or non-admin build access"
  type        = string
  default     = ""
}

variable "build_type" {
  description = "Admin or non-admin build access"
  type        = string
  default     = ""
}

variable "resource" {
  description = "Admin or non-admin build access"
  type        = string
  default     = ""
}

variable "username" {
  description = "Jenkins username"
  type        = string
  default     = ""
}

variable "alerting_thresholds" {
  description = "List of end-user alerting thresholds for ec2s"
  type        = string
  default     = ""
}
