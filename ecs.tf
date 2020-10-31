resource "aws_ecs_task_definition" "nginx_app" {
  family = "ecs-alb-nginx"

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
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "ecs-alb-single-svc-nginx",
        "awslogs-region": "us-east-1"
      }
    },
    "memory": 128,
    "cpu": 100
  }
]
EOF
}


resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.prefix_name}-ecs-cluster"
}

resource "aws_ecs_service" "test-ecs-service" {
  name            = "${var.prefix_name}-ecs-service"
  iam_role        = aws_iam_role.ecs-service-role.name
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.nginx_app.arn
  desired_count   = 2

  load_balancer {
    target_group_arn = aws_alb_target_group.ecs-target-group.arn
    container_port   = 8080
    container_name   = "nginx"
  }
}
