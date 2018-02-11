resource "aws_s3_bucket" "s3" {
  bucket        = "${var.bucket_name}"
  force_destroy = "${var.force_destroy_flag}"

  website {
    index_document = "${var.index_document}"
    error_document = "${var.error_document}"
  }

  versioning {
    enabled = "${var.versioning_flag}"
  }

  provisioner "local-exec" {
    command = "aws s3 cp www/index.html s3://${var.bucket_name}"
  }
}

resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = "${aws_s3_bucket.s3.id}"
  policy = "${data.template_file.tpl.rendered}"
}
