# Security Group Internet to ALB on port 80
resource "aws_security_group" "alb_sg" {
  name        = "${var.prefix_name}-alb-sg"
  vpc_id      = module.vpc.vpc_id
  description = "Allow access on port 80 only to ALB"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an Application Load Balancer in the public subnet 
resource "aws_alb" "ecs-load-balancer" {
  name            = "ecs-load-balancer"
  security_groups = ["${aws_security_group.alb_sg.id}"]
  subnets         = module.vpc.public_subnets

  tags = {
    Name        = var.prefix_name
    Environment = var.environment
  }
}

# ALB Target Group uses port 8080 which is the host port exposed by nginx tasks 
resource "aws_alb_target_group" "ecs-target-group" {
  name     = "ecs-target-group"
  port     = "8080"
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }
  tags = {
    Name        = var.prefix_name
    Environment = var.environment
  }
}

# ALB Listener listens on port 80
resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = aws_alb.ecs-load-balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.ecs-target-group.arn
    type             = "forward"
  }
}

