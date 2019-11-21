variable "name_prefix" {
  description = "Enter your name or unique project description here ( ex: ppresto-dev-ec2 )"
}

variable "region" {
  description = "Enter AWS Region (default: us-west-2)"
  default     = "us-west-2"
}

variable "public" {
  description = "Instance is accessibly from outside (default: true)"
  default     = true
}

variable "instance_type" {
  description = "Select Instance Size (default: t2.micro)"
  type        = "string"
  default     = "t2.micro"
}

variable "egress_cidr_block" {
  description = "Outgoing Traffic (Default: 0.0.0.0/0)"
  type        = "string"
  default     = "0.0.0.0/0"
}

variable "ingress_cidr_block" {
  description = "WARNING: USING 0.0.0.0/0 IS INSECURE! (ex: <public.ipaddress>/32)"
  type        = "string"
  default     = "157.131.174.226/32"
}

variable "http_port" {
  description = "Enable HTTP on port (default: 80)"
  default     = 80
}

variable "https_port" {
  description = "Enable HTTPS on port (default: 443)"
  default     = 443
}

variable "tags" {
  description = "Optional map of tags to set on resources, defaults to empty map."
  type        = "map"
  default     = {}
}

variable "tfe_host" {
  description = "Enter your TFE host ( default: app.terraform.io )"
  default     = "app.terraform.io"
}

variable "tfe_org" {
  description = "Enter your TFE organization ( default: Patrick )"
  default     = "Patrick"
}

variable "tfe_workspace" {
  description = "Enter the workspace managing your VPC ( default: tf-aws-standard-network )"
  default     = "tf-aws-standard-network"
}

variable "security_group" {
  description = "Enter the security group you want applied to your instances"
}

variable "subnetid" {
  description = "Subnet ID (default = subnet_public_ids[0]"
  default = ""
}

variable "instance_count" {
  description = "Number of instances to build"
  default = 1
}

