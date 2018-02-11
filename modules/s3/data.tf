data "template_file" "tpl" {
  template = "${file("${path.module}/files/policy.json")}"

  vars {
    bucket_name = "${aws_s3_bucket.s3.id}"
  }
}
