variable "site_code" {
  description = "All sites code"
  default = {
    us-east-1a = "aaa"
    us-east-1b = "aab"
    us-east-1c = "aac"
    us-east-1d = "aad"
    us-east-1e = "aae"
    us-east-1f = "aaf"
  }
}

variable "byte_length" {
  description = "The number of random bytes to produce. The minimum value is 1, which produces eight bits of randomness."
  type        = number
  default     = 8
}

variable "prefix" {
  description = "Arbitrary string to prefix the output value with. This string is supplied as-is, meaning it is not guaranteed to be URL-safe or base64 encoded."
  type        = string
  default     = "terraform-generated-"
}

variable "name" {
  description = "Name to be used on all resources as prefix"
  type        = string
  default     = null
}

variable "instance_count" {
  description = "Number of instances to launch"
  type        = number
  default     = 1
}

variable "ami" {
  description = "The AMI to use for the instance."
  type        = string
}

variable "placement_group" {
  description = "The Placement Group to start the instance in"
  type        = string
  default     = ""
}

variable "get_password_data" {
  description = "If true, wait for password data to become available and retrieve it."
  type        = bool
  default     = false
}

variable "tenancy" {
  description = "The tenancy of the instance (if the instance is running in a VPC). Available values: default, dedicated, host."
  type        = string
  default     = "default"
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = false
}

variable "disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection"
  type        = bool
  default     = false
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance" # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/terminating-instances.html#Using_ChangingInstanceInitiatedShutdownBehavior
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "The key name to use for the instance"
  type        = string
  default     = ""
}

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  type        = bool
  default     = false
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
}

variable "subnet_ids" {
  description = "A list of VPC Subnet IDs to launch in"
  type        = list(string)
  default     = []
}

variable "associate_public_ip_address" {
  description = "If true, the EC2 instance will have associated public IP address"
  type        = bool
  default     = false
}

variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC"
  type        = string
  default     = ""
}

variable "private_ips" {
  description = "A list of private IP address to associate with the instance in a VPC. Should match the number of instances."
  type        = list(string)
  default     = []
}

variable "source_dest_check" {
  description = "Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs."
  type        = bool
  default     = true
}

variable "user_data" {
  description = "The user data to provide when launching the instance"
  type        = string
  default     = null
}


variable "user_data_base64" {
  description = "Can be used instead of user_data to pass base64-encoded binary data directly."
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "The IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile."
  type        = string
  default     = "service-execution-iam-role"
}

variable "ipv6_address_count" {
  description = "A number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet."
  type        = number
  default     = 0
}

variable "ipv6_addresses" {
  description = "Specify one or more IPv6 addresses from the range of the subnet to associate with the primary network interface"
  type        = list(string)
  default     = []
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
    "fds:OperatingSystem"       = "linux"
    "fds:PatchGroup"            = "base_scan"
    "fds:Platform"              = ""
    "fds:Project"               = ""
    "fds:Provisioner"           = "terraform"
    "fds:ProvisionerVersion"    = ""
    "fds:TaggingVersion"        = "1.0"
    "fds:TerminationSnapshot"   = ""
    "fds:UserEnvironment"       = "dev"
  }
}

variable "name_tag" {
  description = "EC2 tag:name"
  type        = list(string)
  default     = []
}

variable "host_num" {
  description = "EC2 tag:fds:Platform:HostNum"
  type        = list(string)
  default     = []
}

variable "default_host_num" {
  description = "Default EC2 tag:fds:Platform:HostNum"
  type        = string
  default     = "01"
}

variable "volume_name_tag" {
  description = "Volume tag:name"
  type        = list(string)
  default     = []
}

variable "volume_tags" {
  description = "A mapping of tags to assign to the devices created by the instance at launch time"
  type        = map(string)
  default = {
    "fds:BackupSchedule"   = "default"
    "fds:BusinessUnit"     = "Platform Engineering"
    "fds:ConfigManager"    = "terraform"
    "fds:ConfigVersion"    = "terraform"
    "fds:Department"       = "Platform Engineering"
    "fds:InfraEnvironment" = "dev"
    "fds:InfraOwner"       = "quotes_engineer@factset.com"
    "fds:Provisioner"      = "terraform"
    "fds:TaggingVersion"   = "1.0"
    "fds:UserEnvironment"  = "dev"
  }
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type        = list(map(string))
  default     = []
}

variable "ebs_block_device" {
  description = "Additional EBS block devices to attach to the instance"
  type        = list(map(string))
  default     = []
}

variable "ephemeral_block_device" {
  description = "Customize Ephemeral (also known as Instance Store) volumes on the instance"
  type        = list(map(string))
  default     = []
}

variable "network_interface" {
  description = "Customize network interfaces to be attached at instance boot time"
  type        = list(map(string))
  default     = []
}

variable "cpu_credits" {
  description = "The credit option for CPU usage (unlimited or standard)"
  type        = string
  default     = "standard"
}
