variable "prefix_name" {
  description = "Prefix to be used on each AWS infrastructure object"
  default     = "fourthline"
}
variable "environment" {
  description = "AWS tag to indicate environment name of each infrastructure object."
  default     = "dev"
}
variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.small"
}
variable "region" {
  description = "AWS region"
  default     = "eu-west-1"
}
variable "s3_bucket_name" {
  description = "The name of the private s3 bucket"
  default     = "s3-fourthline"
}
variable "asg_min_size" {
  description = "ASG minimum instance size"
  default     = 1
}
variable "asg_max_size" {
  description = "ASG maximum instance size"
  default     = 2
}
variable "asg_desired_capacity" {
  description = "ASG desired capacity"
  default     = 1
}
