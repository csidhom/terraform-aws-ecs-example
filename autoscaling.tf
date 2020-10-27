# Get the latest ECS-optimized image with pre-installed Docker
data "aws_ami" "amazon_linux_ecs" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

# Create ECS security Group
resource "aws_security_group" "ecs_sg" {
    vpc_id      = aws_vpc.vpc.id

    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    ingress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    egress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}

# Create launch configuration and ASG to scale EC2 instances in the private subnet
resource "aws_launch_configuration" "ecs_launch_config" {
    image_id             = data.aws_ami.amazon_linux_ecs.id
    iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
    security_groups      = [aws_security_group.ecs_sg.id]
    user_data            = "#!/bin/bash\necho ECS_CLUSTER=my-cluster >> /etc/ecs/ecs.config"
    instance_type        = var.instance_type
}

resource "aws_autoscaling_group" "ecs_asg" {
    name                      = "${var.prefix_name}-asg"
    vpc_zone_identifier       = module.vpc.private_subnets
    launch_configuration      = aws_launch_configuration.ecs_launch_config.name

    desired_capacity          = 2
    min_size                  = 2
    max_size                  = 2
    health_check_grace_period = 300
    health_check_type         = "EC2"
}
