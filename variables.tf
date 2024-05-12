variable "region" {
  type        = string
  description = "The AWS region to deploy resources"
  default     = "us-east-1"
}

variable "bucket_prefix" {
  type        = string
  description = "The prefix to use for the S3 bucket"
  default     = "tf-s3-ms-iu-"
}

variable "domain_name" {
  type        = string
  description = "The domain name to use for the CloudFront distribution"
  default     = "mattiasanfilippo.tech"
}

variable "media_domain_name" {
  type        = string
  description = "The domain name to use for the S3 bucket"
  default     = "media.mattiasanfilippo.tech"
}

variable "media_content_types" {
  description = "Map of file extensions to their corresponding content types"
  type        = map(string)
  default = {
    "jpg"     = "image/jpeg"
    "jpeg"    = "image/jpeg"
    "png"     = "image/png"
    "gif"     = "image/gif"
    "svg"     = "image/svg+xml"
    "html"    = "text/html"
    "default" = "application/octet-stream"
  }
}

variable "vpc_cidr" {
  type        = string
  default     = "10.10.0.0/16"
  description = "AWS VPC CIDR"
}