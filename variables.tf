variable "region" {
  description = "default: us-west-2"
  default     = "us-west-2"
}

variable "public" {
  description = "Should instance be accessibly from outside (Boolean)"
  default     = true
}

variable "instance_type" {
  description = "Your AWS SSH Key Name Here"
  type        = "string"
  default     = "t2.micro"
}
