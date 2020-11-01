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
# Allows ALB to ECS only and outbound internet access
resource "aws_security_group" "instance_sg" {
  name        = "${var.prefix_name}-instance-sg"
  description = "Allow inbound access from the ALB only"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = "8080"
    to_port         = "8080"
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create launch configuration and ASG to scale EC2 instances in the private subnet 
# The parameter `target_group_arns` is used to attach the ASG to an ALB
resource "aws_launch_configuration" "ecs_launch_config" {
  image_id             = data.aws_ami.amazon_linux_ecs.id
  iam_instance_profile = aws_iam_instance_profile.ecs.id
  security_groups      = [aws_security_group.instance_sg.id]
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=${var.prefix_name}-ecs-cluster >> /etc/ecs/ecs.config"
  instance_type        = var.instance_type
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                 = "${var.prefix_name}-asg"
  vpc_zone_identifier  = module.vpc.private_subnets
  launch_configuration = aws_launch_configuration.ecs_launch_config.name
  target_group_arns    = [aws_alb_target_group.ecs-target-group.arn]

  desired_capacity          = var.asg_desired_capacity
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  health_check_grace_period = 60
  health_check_type         = "ELB"
}
