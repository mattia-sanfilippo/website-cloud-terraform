resource "aws_s3_bucket" "media_bucket" {
  bucket_prefix = var.bucket_prefix

  force_destroy = true
}

# resource "aws_s3_bucket_acl" "media_bucket_acl" {
#   bucket = aws_s3_bucket.media_bucket.id
#   acl    = "private"
# }

resource "aws_s3_bucket_ownership_controls" "media_bucket_acl_ownership" {
  bucket = aws_s3_bucket.media_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }

}

resource "aws_s3_bucket_public_access_block" "media_bucket_public_access_block" {
  bucket = aws_s3_bucket.media_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "media_bucket_sse" {
  bucket = aws_s3_bucket.media_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "media_bucket_policy" {
  bucket = aws_s3_bucket.media_bucket.id

  policy = data.aws_iam_policy_document.media_bucket_policy_document.json
}

resource "aws_s3_object" "media_bucket_object" {
  bucket = aws_s3_bucket.media_bucket.id

  for_each     = fileset("uploads/", "*")
  key          = "media/${each.value}"
  source       = "uploads/${each.value}"
  etag         = filemd5("uploads/${each.value}")
  content_type = lookup(var.media_content_types, lower(element(split(".", each.value), 1)), var.media_content_types["default"])

  depends_on = [aws_s3_bucket.media_bucket]
}