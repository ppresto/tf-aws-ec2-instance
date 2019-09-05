variable "name_prefix" {
  description = "Enter your name or unique project description here."
  default     = "ppresto-ec2-node"
}

variable "region" {
  description = "Enter AWS Region (default: us-west-2)"
  default     = "us-west-2"
}

variable "public" {
  description = "Instance is accessibly from outside (default: true)"
  default     = true
}

variable "count" {
  description = "# of Instances ( default=1 )"
  default     = 1
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
  default     = "0.0.0.0/0"
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