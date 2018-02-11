output "bucket_dns" {
  value = "${aws_s3_bucket.s3.bucket_domain_name}"
}
