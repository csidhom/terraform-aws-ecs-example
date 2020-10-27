# create some variables
variable "prefix_name" {
  type        = string
  description = "Prefix to be used on each AWS infrastructure object"
}
variable "environment_tag" {
  type        = string
  description = "AWS tag to indicate environment name of each infrastructure object."
}

# Get all available AZs in our region
data "aws_availability_zones" "available_azs" {
  state = "available"
}

# Create VPC using the official AWS module
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.44.0"

  name = "${var.prefix_name}-vpc"
  cidr = "10.1.0.0/16"

  azs             = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnets  = ["10.1.11.0/24", "10.1.12.0/24"]
  
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    Name     = var.prefix_name
    Environment = var.environment_tag
  }
}
