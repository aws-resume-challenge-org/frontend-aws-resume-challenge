terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
 
provider "aws" {
  region  = "us-west-2"
  # Commenting out the profile I am using for github action OIDC
  # profile = "test-account"
}


resource "aws_cloudfront_distribution" "resume_cf_distro" {
  aliases                         = [
      "rcarrollresume.com",
  ]

  tags                            = {}
  enabled                         = true
  default_root_object             = "index.html"
  is_ipv6_enabled                 = true

  default_cache_behavior {
    allowed_methods            = [
        "GET", "HEAD",
      ]
    cached_methods             = ["GET", "HEAD"]
    cache_policy_id            = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    compress                   = true
    default_ttl                = 0
    max_ttl                    = 0
    target_origin_id           = "rcarrollresume"
    viewer_protocol_policy     = "redirect-to-https"
  }

  origin {
      connection_attempts      = 3
      connection_timeout       = 10
      domain_name              = "resumebucketcarroll.s3-website-us-west-2.amazonaws.com"
      origin_id                = "rcarrollresume"

      custom_origin_config {
          http_port                = 80
          https_port               = 443
          origin_keepalive_timeout = 5
          origin_protocol_policy   = "http-only"
          origin_read_timeout      = 30
          origin_ssl_protocols     = [
              "SSLv3",
              "TLSv1",
              "TLSv1.1",
              "TLSv1.2",
            ]
        }

      origin_shield {
          enabled              = true
          origin_shield_region = "us-west-2"
        }
    }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
        
  }

  viewer_certificate {
      acm_certificate_arn            = "arn:aws:acm:us-east-1:767397862444:certificate/3b079b8f-ce0c-457b-bff9-b9d482e9e28e"
      cloudfront_default_certificate = false
      minimum_protocol_version       = "TLSv1.2_2021"
      ssl_support_method             = "sni-only"
  }
}


#resource "aws_cloudfront_distribution_invalidation" "invalidation" {
#  distribution_id = aws_cloudfront_distribution.E2E12TP6LTG1FT
#  paths           = ["/*"]
#}