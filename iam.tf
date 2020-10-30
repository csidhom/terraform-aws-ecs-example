/* ecs iam role and policies */
resource "aws_iam_role" "ecs_role" {
  name               = "ecs_role"
  assume_role_policy = file("policies/ecs-role.json")
}

/**
* Attach the ECS container instance role and policy
* The minimal list of permissions is provided 
* in the managed AmazonEC2ContainerServiceforEC2Role policy
*/
resource "aws_iam_role_policy_attachment" "ecs_instance_role_policy" {
  role       = aws_iam_role.ecs_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

/* TODO: Attach policy to access S3 bucket */

/* TODO: ALB role

/**
 * IAM profile to be used in ASG.
 */
resource "aws_iam_instance_profile" "ecs" {
  name  = "ecs-instance-profile"
  path  = "/"
  roles = ["${aws_iam_role.ecs_role.name}"]
}

