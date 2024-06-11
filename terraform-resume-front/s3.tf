

resource "aws_s3_bucket" "resumeBucket" {
  bucket                      = "resumebucketcarroll"
  object_lock_enabled         = false
  tags                        = {}
  tags_all                    = {}
}

# Add ownership Controls
resource "aws_s3_bucket_ownership_controls" "resumeBucket_controls" {
  bucket = aws_s3_bucket.resumeBucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


# Add Server Side Encryption:
resource "aws_s3_bucket_server_side_encryption_configuration" "resumeBucket_encryption" {
  bucket = aws_s3_bucket.resumeBucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Enable Versioning
resource "aws_s3_bucket_versioning" "resumeBucket_versioning" {
  bucket = aws_s3_bucket.resumeBucket.bucket
  versioning_configuration {
    status = "Enabled"
    mfa_delete = "Disabled"
  }
}


# Configure Website
resource "aws_s3_bucket_website_configuration" "resumeBucket_website" {
  bucket = aws_s3_bucket.resumeBucket.bucket
  index_document {
    suffix = "index.html"
  }
}

# Upload Objects without ACLs
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.resumeBucket.bucket
  key    = "index.html"
  source = "${path.module}/resources/index.html"
  acl    = "public-read"

  content_type = "text/html"
}

resource "aws_s3_object" "script" {
  bucket = aws_s3_bucket.resumeBucket.bucket
  key    = "script.js"
  source = "${path.module}/resources/script.js"
  acl    = "public-read"
}

resource "aws_s3_object" "styles" {
  bucket = aws_s3_bucket.resumeBucket.bucket
  key    = "styles.css"
  source = "${path.module}/resources/styles.css"
  acl    = "public-read"
}

# Unblock public access
resource "aws_s3_bucket_public_access_block" "resumeBucket_public_access_block" {
  bucket = aws_s3_bucket.resumeBucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

# Policy to make website accessible
resource "aws_s3_bucket_policy" "resumeBucket_policy" {
  bucket = aws_s3_bucket.resumeBucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid       = "PublicReadGetObject",
      Effect    = "Allow",
      Principal = "*",
      Action    = "s3:GetObject",
      Resource  = "arn:aws:s3:::resumebucketcarroll/*",
    }],
  })
}




