variable "template_name" {
  type        = string
  description = "The name of the launch template. If you leave this blank, Terraform will auto-generate a unique name."
  default     = null
}

variable "accountName" {
  description = "Account Name"
  type        = string
  default     = ""
}

variable "ppgtest" {
  description = "test"
  type        = string
  default     = "pga-eu"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
}

variable "ec2_tags" {
  type        = map(string)
  default     = {}
  description = "EC2 tags (e.g. `map('BusinessUnit`,`XYZ`)"
}

variable "cf_tags" {
  type        = map(string)
  default     = {}
  description = "Cloud Formation Tags tags (e.g. `map('BusinessUnit`,`XYZ`)"
}

variable "volume_tags" {
  type        = map(string)
  default     = {}
  description = "Volume tags (e.g. `map('BusinessUnit`,`XYZ`)"
}

variable "image_id" {
  type        = string
  description = "The EC2 image ID to launch"
  default     = ""
}

variable "instance_initiated_shutdown_behavior" {
  type        = string
  description = "Shutdown behavior for the instances. Can be `stop` or `terminate`"
  default     = "terminate"
}

variable "instance_type" {
  type        = string
  description = "Instance type to launch"
}

variable "iam_instance_profile_name" {
  type        = string
  description = "The IAM instance profile name to associate with launched instances"
  default     = ""
}

variable "key_name" {
  type        = string
  description = "The SSH key name that should be used for the instance"
  default     = ""
}

variable "launch_template_version" {
  type        = string
  description = "Launch template version. Can be version number, `$Latest` or `$Default`"
  default     = ""
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "A list of security group IDs to associate with."
  default     = []
}

variable "user_data_base64" {
  type        = string
  description = "The Base64-encoded user data to provide when launching the instances"
  default     = ""
}

variable "enable_monitoring" {
  type        = bool
  description = "Enable/disable detailed monitoring"
  default     = true
}

variable "ebs_optimized" {
  type        = bool
  description = "If true, the launched EC2 instance will be EBS-optimized"
  default     = false
}

variable "block_device_mappings" {
  description = "Specify volumes to attach to the instance besides the volumes specified by the AMI"
  default     = []
  type        = list(any)
}

variable "instance_market_options" {
  description = "The market (purchasing) option for the instances"

  type = object({
    market_type = string
    spot_options = object({
      block_duration_minutes         = number
      instance_interruption_behavior = string
      max_price                      = number
      spot_instance_type             = string
      valid_until                    = string
    })
  })

  default = null
}

variable "placement" {
  description = "The placement specifications of the instances"

  type = object({
    affinity          = string
    availability_zone = string
    group_name        = string
    host_id           = string
    tenancy           = string
  })

  default = null
}

variable "network_interfaces" {
  description = "Attaches one or more Network Interfaces to the instance."
  type        = list(any)
  default     = []
}

variable "credit_specification" {
  description = "Customize the credit specification of the instances"

  type = object({
    cpu_credits = string
  })

  default = null
}

variable "elastic_gpu_specifications" {
  description = "Specifications of Elastic GPU to attach to the instances"

  type = object({
    type = string
  })

  default = null
}

variable "disable_api_termination" {
  type        = bool
  description = "If `true`, enables EC2 Instance Termination Protection"
  default     = false
}

variable "autoscaling_group_name" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = "quotes-autoscaling"
}

variable "max_size" {
  type        = number
  description = "The maximum size of the autoscale group"
}

variable "min_size" {
  type        = number
  description = "The minimum size of the autoscale group"
}

variable "subnet_ids" {
  description = "A list of subnet IDs to launch resources in"
  type        = list(string)
  default     = []
}

variable "availability_zones" {
  description = "A list of availability zones to launch resources in"
  type        = list(string)
  default     = []
}

variable "default_cooldown" {
  type        = number
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start"
  default     = 300
}

variable "health_check_grace_period" {
  type        = number
  description = "Time (in seconds) after instance comes into service before checking health"
}

variable "health_check_type" {
  type        = string
  description = "Controls how health checking is done. Valid values are `EC2` or `ELB`"
  default     = "EC2"
}

variable "desired_capacity" {
  type        = number
  description = "The number of Amazon EC2 instances that should be running in the group."
}

variable "metrics_collections" {
  description = "A list of metrics to collect. The allowed values are `GroupMinSize`, `GroupMaxSize`, `GroupDesiredCapacity`, `GroupInServiceInstances`, `GroupPendingInstances`, `GroupStandbyInstances`, `GroupTerminatingInstances`, `GroupTotalInstances`"
  type    = list
  default = [
        "GroupMinSize",
        "GroupMaxSize",
        "GroupDesiredCapacity",
        "GroupInServiceInstances",
        "GroupPendingInstances",
        "GroupStandbyInstances",
        "GroupTerminatingInstances",
        "GroupTotalInstances"
      ]
    }

variable "metrics_granularity" {
  type        = string
  default     = "1Minute"
  description = "Time granularity for enabled metrics_collection values"
}

variable "suspended_processes" {
  description = "A list of Auto Scaling Group Processes to Suspend"
  type    = list
  default = []
    }

variable "asg_tags" {
  type        = list(map(string))
  default     = []
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
}

variable "rolling_update" {
  default     = {}
  description = "Rolling update"
}

variable "replacing_update" {
  type        = map(string)
  default     = {}
  description = "Replacing update"
}

variable "cf_stack_name" {
  type        = string
  default     = "default-asg-stack"
  description = "Stack name."
}

variable "lifecycle_hook_specification" {
  default     = []
  description = "he lifecycle hooks for the group, which specify actions to perform when Amazon EC2 Auto Scaling launches or terminates instances."
}

variable "loadbalancer_names" {
  type        = list(string)
  default     = []
  description = "A list of Classic Load Balancers associated with this Auto Scaling group. For Application Load Balancers and Network Load Balancers, specify a list of target groups using the TargetGroupARNs property instead."
}

variable "notification_configurations" {
  default     = []
  description = "Configures an Auto Scaling group to send notifications when specified events take place."
}

variable "placement_group" {
  type        = string
  default     = ""
  description = "The name of an existing cluster placement group into which you want to launch your instances. A placement group is a logical grouping of instances within a single Availability Zone. You cannot specify multiple Availability Zones and a placement group."
}

variable "service_linked_role_arn" {
  type        = string
  default     = ""
  description = "The Amazon Resource Name (ARN) of the service-linked role that the Auto Scaling group uses to call other AWS services on your behalf. By default, Amazon EC2 Auto Scaling uses a service-linked role named AWSServiceRoleForAutoScaling, which it creates if it does not exist."
}

variable "target_group_arns" {
  type        = any
  default     = []
  description = "A list of Amazon Resource Names (ARN) of target groups to associate with the Auto Scaling group. Instances are registered as targets in a target group, and traffic is routed to the target group."
}

variable "termination_policies" {
  type        = list(string)
  default     = []
  description = "A policy or a list of policies that are used to select the instances to terminate. The policies are executed in the order that you list them. The termination policies supported by Amazon EC2 Auto Scaling: OldestInstance, OldestLaunchConfiguration, NewestInstance, ClosestToNextInstanceHour, Default, OldestLaunchTemplate, and AllocationStrategy."
}

variable "timeout_in_minutes" {
  type        = number
  default     = 60
  description = "The amount of time that can pass before the stack status becomes `CREATE_FAILED`"
}

variable "min_healthy_percentage" {
  type        = number
  description = "The ptage of instance that must be in a healthy state before in an instance refresh occurs"
}

variable "instance_warmup" {
  type        = number
  description = "The amount of time in seconds to elapse before a new instance is placed inside an Auto Scaling Group. Default's to 'health_check_grace_period' setting if left blank."
}

variable "strategy" {
  type        = string
  default     = "Rolling"
  description = "The instance refresh strategy for instance replacement inside an Auto Scaling Group."
}

variable "heartbeat_timeout" {
  type        = number
  description = "The amount of time in seconds to elapse before a new instance is placed inside an Auto Scaling Group. Default's to 'health_check_grace_period' setting if left blank."
}