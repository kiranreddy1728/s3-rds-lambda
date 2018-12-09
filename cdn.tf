// Cloud Front Distribution
resource "aws_cloudfront_distribution" "offers_distribution" {
  origin {
    domain_name = "${aws_api_gateway_rest_api.rewardsapi.id}.execute-api.$(var.region).amazon.com"
    origin_path = "/${var.stage_name}"
    origin_id = "${var.target_origin_id}"
    //domain_name = "${aws_s3_bucket.b.bucket_regional_domain_name}"
    //origin_id   = "${local.s3_origin_id}"

    custom_origin_config {
        http_port = 80
        https_port = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
        origin_keepalive_timeout = 30
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.target_origin_id}"
    //target_origin_id = "${local.s3_origin_id}"
    

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  cache_behavior {
    path_pattern     = "*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "myoffersOrigin"
    //target_origin_id = "${local.s3_origin_id}"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

output "cdnid" {
  value = "${aws_cloudfront_distribution.offers_distribution.id}"
}
