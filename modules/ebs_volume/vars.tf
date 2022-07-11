variable "availability_zone" {
  description = "The AZ where the EBS volume will exist."
  type        = list
}

variable "ebs_volume_size" {
  description = "The size of the drive in GiBs."
  type        = string
  default     = "10"
}

variable "ebs_volume_type" {
  description = "The type of EBS volume."
  type        = string
  default     = "standard"
}

variable "enable_encrypted" {
  description = "If true, the disk will be encrypted."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default = {
    "fds:AppVersion"            = ""
    "fds:BackupSchedule"        = "default"
    "fds:BusinessUnit"          = "Platform Engineering"
    "fds:Client"                = ""
    "fds:Cluster"               = ""
    "fds:ComplianceRequirement" = ""
    "fds:ConfigManager"         = "terraform"
    "fds:ConfigVersion"         = "terraform"
    "fds:Criticality"           = ""
    "fds:DataClassification"    = ""
    "fds:Department"            = "Platform Engineering"
    "fds:DisasterRecovery"      = ""
    "fds:ExpiryDate"            = ""
    "fds:Function"              = ""
    "fds:InfraEnvironment"      = "dev"
    "fds:InfraOwner"            = "quotes_engineer@factset.com"
    "fds:MaintenanceWindow"     = ""
    "fds:Platform"              = ""
    "fds:Project"               = ""
    "fds:Provisioner"           = "terraform"
    "fds:ProvisionerVersion"    = ""
    "fds:TaggingVersion"        = "1.0"
    "fds:TerminationSnapshot"   = ""
    "fds:UserEnvironment"       = "dev"
  }
}