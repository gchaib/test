resource "aws_cloudfront_distribution" "cloudfront" {
  default_root_object = "index.html"
  enabled             = "true"

  origin {
    domain_name = "${var.bucket_dns}"
    origin_id   = "${var.bucket_dns}"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = "true"
  }

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${var.bucket_dns}"
    viewer_protocol_policy = "allow-all"

    default_ttl = "86400"
    max_ttl     = "31536000"
    min_ttl     = "0"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }
}
