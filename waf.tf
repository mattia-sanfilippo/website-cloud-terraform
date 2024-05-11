resource "aws_wafv2_web_acl" "waf" {
  name        = "tf-cloudfront-alb-waf"
  description = "WAF for CloudFront, rate limiting requests"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "rule-1"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit = 100
        aggregate_key_type = "IP"

        scope_down_statement {
          geo_match_statement {
            country_codes = ["IT"]
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "waf-rate-limiting"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "waf-rate-limiting-hits"
    sampled_requests_enabled   = false
  }
}
