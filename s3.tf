# Create an S3 private bucket
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_bucket_name
  acl    = "private"

  tags = {
    Name        = var.prefix_name
    Environment = var.environment
  }
}

/* Use the value of 's3_bucket_name' in the policy file */
resource "template_file" "s3_policy" {
  template = file("policies/s3-policy.json")

  vars {
    s3_bucket_name = var.s3_bucket_name
  }
}
