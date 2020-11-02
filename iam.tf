#---------------------------------------------------
# IAM Role for EC2 instances used in the ASG 
#---------------------------------------------------
resource "aws_iam_role" "ecs_role" {
  name               = "ecs_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_instance_policy.json
}

data "aws_iam_policy_document" "ecs_instance_policy" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

# Attach the ECS container instance role and policy
# The minimal list of permissions is provided in the managed AmazonEC2ContainerServiceforEC2Role policy
resource "aws_iam_role_policy_attachment" "ecs_instance_role_policy" {
  role       = aws_iam_role.ecs_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# IAM profile to be used in ASG.
resource "aws_iam_instance_profile" "ecs" {
  name = "ecs-instance-profile"
  path = "/"
  role = aws_iam_role.ecs_role.name
}

#---------------------------------------------------
# IAM Policy for ECS tasks to write objects in S3 
#---------------------------------------------------
# AWS IAM role for ECS tasks to assume a role
resource "aws_iam_role" "ecs_task_role" {
  name               = "ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_policy.json
}

# IAM policy document allowing ECS tasks to assume a role
data "aws_iam_policy_document" "ecs_task_policy" {
  statement {
    sid = ""
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}


#  IAM policy to define S3 write object permission
data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    sid = ""
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.s3_bucket.bucket}/*"
    ]
  }
}

# S3 IAM policy
resource "aws_iam_policy" "s3_policy" {
  name   = "s3-task-policy"
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}

# Attach the IAM policy to an ECS task IAM role 'ecs_task_role' 
resource "aws_iam_role_policy_attachment" "ecs_role_s3_data_bucket_policy_attach" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}


#---------------------------------------------------
# IAM role for ALB service role
#---------------------------------------------------
resource "aws_iam_role" "ecs-service-role" {
  name               = "ecs-service-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs-service-policy.json
}

resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment" {
  role       = aws_iam_role.ecs-service-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy_document" "ecs-service-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}
