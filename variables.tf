variable "namespace" {
  description = "Enter your name or unique description here (default: your-project-name)"
  default     = "your-project-name"
}

variable "region" {
  description = "default: us-west-2"
  default     = "us-west-2"
}

variable "public" {
  description = "Instance is accessibly from outside (default: true)"
  default     = true
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
  description = "Trusted Incoming Traffic (EX: <YOUR_PUBLIC_IP>/32)\n WARNING: USING 0.0.0.0/0 IS INSECURE!"
  type        = "string"
  default     = "0.0.0.0/0"
}
