variable "name" {
  description = "The name of the placement group."
  type        = string
  default     = "quotes_ppg"
}

variable "strategy" {
  description = "The placement strategy. Can be 'cluster', 'partition' or 'spread'."
  type        = string
  default     = "cluster"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map
  default = {
    "fds:Provisioner" = "terraform"
  }
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "pga" {
  description = "The name of the placement group."
  type        = string
  default     = "pga"
}

variable "pgb" {
  description = "The name of the placement group."
  type        = string
  default     = "pgb"
}

variable "pgA-am" {
  description = "The name of the placement group."
  type        = string
  default     = "pgA-am"
}

/*variable "sg_name" {
  description = "Security group name"
  type        = list(string)
  default     = ["fds-default-compute-secgroup", "fds-default-additional-secgroup"]
}*/

variable "image_name" {
  description = "AMI Image Name"
  type        = string
  default     = ""
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

variable "ssm_account_name_paramter" {
  description = "SSM account name parameter"
  type        = string
  default     = "/fdscloud/account_name"
}

variable "private_vpc" {
  description = "Default Platform's private vpc regex"
  type        = list(string)
  default     = ["sbu-content-*-*-*-vpc-1"]
}

variable "vm_count" {
  description = "Number of instances to launch"
  type        = number
  default     = 1
}

variable "vm_count_end" {
  description = "Number of instances to launch"
  type        = number
  default     = 0
}

variable "vm_size" {
  description = "The type of instance to start"
  type        = string
  default     = ""
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

variable "zones" {
  description = "availability zone"
  type        = list(string)
  default     = ["us-east-1c"]
}

variable "subnet_tag_name" {
  description = "Default Platform's subnet name regex"
  type        = list(string)
  default     = ["{\"purpose\": \"compute\"}"]
}


variable "sg_rules" {
  description = "A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend_protocol, backend_port"
  type        = map
  default     = { 
    fds-default-additional-secgroup1 = {
      sg_ingress = [{
        from_port = 32768
        to_port = 60999
        protocol = "TCP"
        description = "Unix ephemeral - On-prem"
        cidr_blocks = ["10.0.0.0/8"]
        self = false
        },
        {
        from_port = 32768
        to_port = 60999
        protocol = "TCP"
        description = "Unix ephemeral - On-prem"
        cidr_blocks = ["164.55.0.0/16"]
        self = false
        },
        {
        from_port = 32768
        to_port = 60999
        protocol = "TCP"
        description = "Unix ephemeral - On-prem"
        cidr_blocks = ["172.16.0.0/12"]
        self = false
        }]
    }
    fds-default-additional-secgroup2 = {
      sg_ingress = [{
        from_port = 11000
        to_port = 12000
        protocol = "TCP"
        description = "ZML Intra Secgroup Allow Ingress"
        cidr_blocks = []
        self = true
        }]
    }
  }
}

/*variable "sg_rules" {
  description = "A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend_protocol, backend_port"
  type        = any
  default = [{
   from_port = 32768
   to_port = 60999
   protocol = "TCP"
   description = "Unix ephemeral - On-prem"
   cidr_blocks = "10.0.0.0/8"
   self = false
  },
  {
   from_port = 32768
   to_port = 60999
   protocol = "TCP"
   description = "Unix ephemeral - On-prem"
   cidr_blocks = "164.55.0.0/16"
   self = false
  },
  {
   from_port = 32768
   to_port = 60999
   protocol = "TCP"
   description = "Unix ephemeral - On-prem"
   cidr_blocks = "172.16.0.0/12"
   self = false
   }]
}*/

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

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null
}

variable "revoke_rules_on_delete" {
  description = "Instruct Terraform to revoke all of the Security Groups attached ingress and egress rules before deleting the rule itself. "
  type        = bool
  default     = false
}

variable "vm_type" {
  description = "The type of instance to start"
  type        = string
  default     = ""
}

variable "accountName" {
  description = "Account name"
  type        = string
  default     = ""
}

variable "pg_prefix" {
  description = "Account name"
  type        = string
  default     = ""
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

variable "param_workspace_name" {
  description = "Terraform workspace name"
  type        = string
  default     = "no_ws_defined"
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
