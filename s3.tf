# Create an S3 private bucket
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_bucket_name
  acl    = "private"

  tags = {
    Name        = var.prefix_name
    Environment = var.environment
  }
}
