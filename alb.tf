/*
* Define the ALB Security Group
* Allow inbound traffic on port 80 from anywhere
* Allow outbound traffic on all ports
*/
resource "aws_security_group" "alb_sg" {
  name   = "${var.prefix_name}-alb-sg"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "inbound_access" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "outbound_internet_access" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

/* Create an Application Load Balancer in the public subnet */
resource "aws_alb" "ecs-load-balancer" {
  name            = "ecs-load-balancer"
  security_groups = ["${aws_security_group.alb_sg.id}"]
  subnets         = module.vpc.public_subnets

  tags = {
    Name        = var.prefix_name
    Environment = var.environment
  }
}

resource "aws_alb_target_group" "ecs-target-group" {
  name     = "ecs-target-group"
  port     = "80"
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

resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = aws_alb.ecs-load-balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.ecs-target-group.arn
    type             = "forward"
  }
}

