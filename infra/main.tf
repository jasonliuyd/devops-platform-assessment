resource "aws_s3_bucket" "platform_artifacts" {
  bucket = "devops-platform-assessment-artifacts-example"
}

# Enable versioning to protect artifact history
resource "aws_s3_bucket_versioning" "platform_artifacts" {
  bucket = aws_s3_bucket.platform_artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption using AWS KMS
resource "aws_s3_bucket_server_side_encryption_configuration" "platform_artifacts" {
  bucket = aws_s3_bucket.platform_artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "platform_artifacts" {
  bucket = aws_s3_bucket.platform_artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Lifecycle management
resource "aws_s3_bucket_lifecycle_configuration" "platform_artifacts" {
  bucket = aws_s3_bucket.platform_artifacts.id

  rule {
    id     = "artifact-retention"
    status = "Enabled"

    filter {}

    expiration {
      days = 90
    }

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}
