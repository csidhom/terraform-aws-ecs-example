resource "template_file" "ecs_service_role_policy" {
  template = "${file("policies/s3-policy.json")}"

  vars {
    s3_bucket_name = "${var.s3_bucket_name}"
  }
}
