variable "namespace" {
  description = "default: us-west-2"
  default     = "your-project-name"
}

variable "region" {
  description = "default: us-west-2"
  default     = "us-west-2"
}

variable "public" {
  description = "Should instance be accessibly from outside (Boolean)"
  default     = true
}

variable "instance_type" {
  description = "instance size"
  type        = "string"
  default     = "t2.micro"
}

variable "egress_cidr_block" {
  description = "Outgoing Traffic trusted locations (Default: 0.0.0.0/0)"
  type        = "string"
  default     = "0.0.0.0/0"
}

variable "ingress_cidr_block" {
  description = "Trusted Incoming Traffic cidr_block (EX: <YOUR_PUBLIC_IP>/32)"
  type        = "string"
  default     = "0.0.0.0/0"
}
