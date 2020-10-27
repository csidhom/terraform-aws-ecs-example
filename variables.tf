variable "prefix_name" {
  type        = string
  description = "Prefix to be used on each AWS infrastructure object"
}

variable "environment" {
  type        = string
  description = "AWS tag to indicate environment name of each infrastructure object."
}
variable "instance_type" {
  default = "t2.small"
  type    = string
}
variable "region" {
  description = "AWS region"
  default     = "eu-west-1"
}
