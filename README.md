
# Terraform ECS App

## Introduction

This repo contains the Terraform plan to deploy an ECS cluster on EC2 running two parallel nginx tasks.
It is an attempt to complete the three layers of the assignmentn and will provision the following AWS resources:

- **VPC** with single nat gateway, two public subnets and two private subnets across two distinct AZs
- **ECS** service running one service with two parallel nginx tasks exposed on port 8080
- **Private S3 Bucket** accessible from the nginx tasks
- **Application Load Balancer** that forwards requests from port 80 to the nginx tasks
- **Auto Scaling Group** and **Launch Configuration** for the ECS instances
- **IAM roles** for ECS container instance, for ALB and for accessing S3 from the EC2  
- **Security Groups** to only allow traffic to the ECS instances from the ALB on port 8080

 
Terraform modules used
 
- [terraform-aws-vpc](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.54.0)

## Required Software
- Terraform ">= 0.13"

## Instructions

## Further Improvements

- Use spot instances for the ASG

## Contact
**email** : chaker.sidhom@gmail.com
