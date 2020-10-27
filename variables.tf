variable "prefix_name" {
  type        = string
  description = "Prefix to be used on each AWS infrastructure object"
}

variable "environment" {
  type        = string
  description = "AWS tag to indicate environment name of each infrastructure object."
}

variable "region" {
  description = "AWS region"
  default     = ""
}
