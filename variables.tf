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
