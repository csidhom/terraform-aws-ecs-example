# Service role allowing AWS to manage resources required for ECS
resource "aws_iam_service_linked_role" "ecs_service" {
  aws_service_name = "ecs.amazonaws.com"
}

# Task Definition
resource "aws_ecs_task_definition" "nginx_app" {
  family                = "ecs-alb-nginx"
  network_mode          = "awsvpc"
  container_definitions = <<EOF
[
  {
    "name": "nginx",
    "image": "nginx:1.13-alpine",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80
        "hostPort":8080
      }
    ],
    "memory": 128,
    "cpu": 100
  }
]
EOF
}


resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.prefix_name}-ecs-cluster"
}

# Service Definition
resource "aws_ecs_service" "ecs-service" {
  name            = "${var.prefix_name}-ecs-service"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.nginx_app.arn
  desired_count   = 2

  network_configuration {
    subnets = module.vpc.private_subnets
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.ecs-target-group.arn
    container_port   = 8080
    container_name   = "nginx"
  }
}
