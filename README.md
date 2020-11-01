
# Terraform ECS App

## Introduction

This solution is divided into three main terraform modules:

The application is an Nginx app, which simply uses the nginx docker image.
 
Terraform modules used
 
- [terraform-aws-vpc](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.54.0)

## Required Software
- Terraform ">= 0.13"

## Instructions

 1. Clone or Download the project source

    To clone the project, request access to the private repo from "chaker.sidhom@gmail.com"
	 
	``` bash
	git clone https://github.com/csidhom/fourthline.git
	cd fourthline
	```
 2. Deploy the infrastructure


    Next apply the terraform modules:
 
	 ``` bash
	 $ terraform init
	 $ terraform apply
	 ```
	 After approving the plan, terraform will spin up the infrastructure.
	  
 3. Access the App
	Once the apply command finishes successfully, the Load Balancer DNS is printed as an output. Example
        ```
        Outputs:
        alb_dns_name = ecs-load-balancer-1761861875.eu-west-1.elb.amazonaws.com
        ```

 5. Clean up the infrastructure 

       ``` bash
	   $ terraform destroy
       ```
## Further Improvements

- Create a Bastion server to access the worker nodes through SSH
- Use spot instances for the ASG

## Contact
**email** : chaker.sidhom@gmail.com
