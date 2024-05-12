#creating CF distribution :
resource "aws_cloudfront_distribution" "cf_dist" {
  enabled = true
  aliases = [var.domain_name]

  web_acl_id = aws_wafv2_web_acl.waf.arn

  origin {
    domain_name = aws_lb.alb.dns_name
    origin_id   = aws_lb.alb.dns_name

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = aws_lb.alb.dns_name
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers      = []
      query_string = true

      cookies {
        forward = "all"
      }
    }

  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["IT"]
    }
  }

  tags = local.tags

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }
}


resource "aws_cloudfront_distribution" "cf_media_dist" {
  enabled = true
  aliases = [var.media_domain_name]

  web_acl_id = aws_wafv2_web_acl.waf.arn

  origin {
    domain_name = aws_s3_bucket.media_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.media_bucket.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.media_oai.cloudfront_access_identity_path
    }
  }


  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.media_bucket.id
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      headers      = []
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["IT"]
    }
  }

  depends_on = [aws_acm_certificate.cert]

}

resource "aws_cloudfront_origin_access_identity" "media_oai" {
  comment = "OAI for ${var.media_domain_name}"
}
