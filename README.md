
# Terraform ECS App

## Introduction

This solution is divided into three main terraform modules:

 1. **VPC**
    This module is responsible for creating the VPC, with two public subnets which will be used by the public Load Balancers, two private subnets for ECS nodes.
    In addition to the Internet Gateway and the required security groups

 2. **ECS**
    Creates an EKS cluster, with the appropriate IAM roles.
    Also an EKS managed node group, with EC2 Autoscaling Group and Launch Configuration. All worker nodes are configured to be deployed on the private subnets.
    Finally generates a KUBECONFIG file to authenticate kubectl.

 3. **ALB**
    Creates an RDS managed PostgeSQL DB with the appropriate security rules to accept traffic from the private subnets created by the VPC module, on the Postgres port `5432`. 

The application is an Nginx app, which simply uses the nginx:1.19.2 docker image.
The file [k8s.template.yml](./k8s.template.yml), defines a Service resource of type LoadBlancer which will deploy a publicly accessible AWS Classic Load Balancer in one of the public subnets defined previously. This service's IP will be the single entry point to access the app.
 
**Note** : the following terraform modules are used
 
- [terraform-aws-vpc](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.54.0)
- [terraform-aws-rds](https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/2.18.0)
- [terraform-aws-eks](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/12.2.0) 

## Required Software
- Terraform ">= 0.12.6"

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
	 After approving the plan, terraform will spin up the infrastructure. In addition, the config file  `kubeconfig_<cluster-name>` (By default  `kubeconfig_terraform-eks-demo`) will be generated.
	  
 3. Configure `kubectl`
	 Assuming `kubectl` is installed, we need to use the generated config file in order to interact with the remote EKS cluster. For example:
	 ``` bash 
	 export KUBECONFIG=$KUBECONFIG:${PWD}/kubeconfig_terraform-eks-demo
	 ```
	 You can test the access to the remote EKS cluster as follows:
	 ``` bash
	$ kubectl get svc
	NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
	kubernetes   ClusterIP   172.20.0.1   <none>        443/TCP   58m 
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
