resource "aws_s3_bucket" "platform_artifacts" {
  bucket = "devops-platform-assessment-artifacts-example"

  lifecycle {
    prevent_destroy = true
  }
}

# Enable bucket versioning
resource "aws_s3_bucket_versioning" "platform_artifacts" {
  bucket = aws_s3_bucket.platform_artifacts.id

  versioning_configuration {
    status = "Enabled"
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

# Enable encryption at rest
resource "aws_s3_bucket_server_side_encryption_configuration" "platform_artifacts" {
  bucket = aws_s3_bucket.platform_artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
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
  }
}
