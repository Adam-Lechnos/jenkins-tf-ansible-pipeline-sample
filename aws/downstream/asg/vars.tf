variable "runtime_data" {
  description = "Dynamic data to be used in cloudinit script"
  type        = string
  default     = ""
}

variable "accountName" {
  description = "Account name"
  type        = string
  default     = ""
}

variable "ppgtest" {
  description = "test"
  type        = string
  default     = "pga-eu"
}

variable "pg_prefix" {
 description = "Placement Group Prefix"
 type        = list(string)
 default     = ["sbu-content-dev-compute-a-1", "sbu-content-dev-compute-b-1", "sbu-content-dev-compute-c-1"]
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ssm_account_name_parameter" {
  description = "SSM account name parameter"
  type        = string
  default     = "/fdscloud/account_name"
}

variable "ssm_account_environment_parameter" {
  description = "SSM account name parameter"
  type        = string
  default     = "/fdscloud/environment"
}

variable "ami_owner_list" {
  description = "AMI Owner's list"
  type        = list(string)
  default     = ["self","053821600536"]
}

variable "image_name" {
  description = "AMI Image Name"
  type        = string
  default     = ""
}

variable "image_name_trimmed" {
  description = "AMI Image Name Trimmed for CF Name"
  type        = string
  default     = ""
}

variable "image_version" {
  description = "AMI Image Version"
  type        = string
  default     = "latest"
}

variable "image_version_trimmed" {
  description = "AMI Version Trimmed for CF Name"
  type        = string
  default     = ""
}

variable "param_workspace_name" {
  description = "Terrform workspace name"
  type        = string
  default     = ""
}

variable "param_workspace_name_trimmed" {
  description = "Terrform workspace name Trimmed"
  type        = string
  default     = ""
}

variable "private_vpc" {
  description = "Default Platform's private vpc regex"
  type        = list(string)
  default     = ["sbu-content-*-*-*-vpc-1"]
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

variable "scaleset_prefix" {
  description = "Autoscaling group name"
  type        = string
  default     = "template-quotes-asg"
}

variable "scaleset_prefix_trimmed" {
  description = "Autoscaling group name"
  type        = string
  default     = "template-quotes-asg"
}

variable "vm_type" {
  description = "The type of instance to start"
  type        = string
  default     = "c5n.large"
}

variable "block_device_mappings" {
  description = "Customize details about the root block device of the instance"
  type        = list(any)
  default = [{
    device_name = "/dev/sda1"
    ebs = {
      volume_size           = "50"
      volume_type           = "gp2"
      encrypted             = "false"
      delete_on_termination = "true"
    }
  }]
}

variable "iam_instance_profile_name" {
  description = "The IAM Instance Profile to launch the instance with"
  type        = string
  default     = "service-execution-iam-role"
}

variable "vmss_tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default = {
    "fds:BusinessUnit"     = "Content Engineering"
    "fds:InfraEnvironment" = "dev"
    "fds:InfraOwner"       = "quotes_engineer@factset.com"
    "fds:Provisioner"      = "terraform"
    "fds:TaggingVersion"   = "1.0"
  }
}

variable "desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group."
  type        = number
  default     = 0
}

variable "vm_count" {
  description = "Default ASG fleet count."
  type        = number
  default     = 0
}

variable "max_size" {
  description = "The maximum size of the auto scale group."
  type        = number
  default     = 0
}

variable "min_size" {
  description = "The minimum size of the auto scale group."
  type        = number
  default     = 0
}

variable "health_check_type" {
  description = "'EC2' or 'ELB'. Controls how health checking is done."
  type        = string
  default     = "EC2"
}

variable "health_check_grace_period" {
  description = "(Optional, Default: 300) Time (in seconds) after instance comes into service before checking health."
  type        = number
  default     = 60
}

variable "enable_monitoring" {
  description = "Enable monitoring"
  type        = bool
  default     = false
}

variable "metrics_collections" {
  description = "A list of metrics to collect. The allowed values are `GroupMinSize`, `GroupMaxSize`, `GroupDesiredCapacity`, `GroupInServiceInstances`, `GroupPendingInstances`, `GroupStandbyInstances`, `GroupTerminatingInstances`, `GroupTotalInstances`"
  default     = []
}

variable "suspended_processes" {
  description = "A list of Auto Scaling Group Processes to Suspend"
  type    = list
  default = []
}

variable "rolling_upgrade_policy" {
  description = "Rolling update"
  type = object({
    MaxBatchSize          = number
    MinInstancesInService = number
    PauseTime             = string
    SuspendProcesses      = list(string)
  })
  default = {
    "MinInstancesInService" : "1",
    "MaxBatchSize" : "1",
    "PauseTime" : "PT0S",
    "SuspendProcesses" : [
      "HealthCheck",
      "ReplaceUnhealthy",
      "AZRebalance",
      "AlarmNotification",
      "ScheduledActions",
      "AddToLoadBalancer"
    ]
  }
}

variable "proximity_placement_group_name" {
  type        = string
  default     = ""
  description = "The name of an existing cluster placement group into which you want to launch your instances. A placement group is a logical grouping of instances within a single Availability Zone. You cannot specify multiple Availability Zones and a placement group."
}

variable "sg_description" {
  description = "Additional security group description."
  type        = string
  default     = "Developer specified rules for intra-ec2 networking"
}

variable "sg_egress" {
  description = "A list of Egress blocks"
  type        = list(any)
  default = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

variable "sg_tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default = {
    "fds:BusinessUnit"     = "Content Engineering"
    "fds:InfraEnvironment" = "dev"
    "fds:InfraOwner"       = "quotes_engineer@factset.com"
    "fds:Provisioner"      = "terraform"
    "fds:TaggingVersion"   = "1.0"
  }
}

variable "user_defined_sg_ingress" {
  description = "User defined security group ingress"
  type        = list(any)
  default     = [{
    from_port = 11000
    to_port = 12000
    protocol = "TCP"
    self = true
    }
  ]
}

variable "cf_tags" {
  type        = map(string)
  default     = {}
  description = "Cloud Formation Tags tags (e.g. `map('BusinessUnit`,`XYZ`)"
}

variable "git_repo" {
  type        = string
  default     = ""
  description = "Referenced Git Repo for build"
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

variable "min_healthy_percentage" {
  type        = number
  default     = 50
  description = "The percentage of instance that must be in a healthy state before in an instance refresh occurs"
}

variable "instance_warmup" {
  type        = number
  default     = 30
  description = "The amount of time in seconds to elapse before a new instance is placed inside an Auto Scaling Group. Default's to 'health_check_grace_period' setting if left blank."
}

variable "strategy" {
  type        = string
  default     = "Rolling"
  description = "The instance refresh strategy for instance replacement inside an Auto Scaling Group."
}

variable "heartbeat_timeout" {
  type        = number
  default     = 30
  description = "The amount of time in seconds to elapse before a new instance is placed inside an Auto Scaling Group. Default's to 'health_check_grace_period' setting if left blank."
}
