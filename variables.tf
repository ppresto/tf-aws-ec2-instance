variable "name_prefix" {
  description = "Enter your name or unique description here."
}

variable "region" {
  description = "default: us-west-2"
  default     = "us-west-2"
}

variable "public" {
  description = "Instance is accessibly from outside (default: true)"
  default     = true
}

variable "count" {
  description = "Instance count (default=1)"
  default     = 1
}

variable "instance_type" {
  description = "instance size (default: t2.micro)"
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
