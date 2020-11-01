terraform {
  required_version = ">= 0.13"
}
provider "aws" {
  version = "~> 2.57.0"
  region  = var.region
}

