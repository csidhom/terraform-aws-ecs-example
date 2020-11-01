# Task Definition
# Using the default network 'bridge', this is because we need dynamic port mapping
# Containers expose nginx port 80 to the host port 8080
resource "aws_ecs_task_definition" "nginx_app" {
  family                = "ecs-alb-nginx"
  container_definitions = <<EOF
[
  {
    "name": "nginx",
    "image": "nginx:1.13-alpine",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort":8080
      }
    ],
    "memory": 128,
    "cpu": 100
  }
]
EOF
}

# Create ECS cluster
resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.prefix_name}-ecs-cluster"
}

# Service Definition runnig two parallel tasks
resource "aws_ecs_service" "ecs-service" {
  # Adding this dependancy to prevent race condition during creation and deletion
  depends_on = [
    aws_ecs_task_definition.nginx_app,
    aws_alb_target_group.ecs-target-group,
    aws_iam_role.ecs-service-role,
    aws_alb_listener.alb-listener
  ]
  name            = "${var.prefix_name}-ecs-service"
  iam_role        = aws_iam_role.ecs-service-role.name
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.nginx_app.arn
  desired_count   = 2

  load_balancer {
    target_group_arn = aws_alb_target_group.ecs-target-group.arn
    container_port   = 80
    container_name   = "nginx"
  }
}
