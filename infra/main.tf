
# Main artifact bucket
resource "aws_s3_bucket" "platform_artifacts" {
  bucket = "devops-platform-assessment-artifacts-example"

  lifecycle {
    prevent_destroy = true
  }
}

# Enable versioning
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

# KMS encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "platform_artifacts" {
  bucket = aws_s3_bucket.platform_artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

# Separate bucket for access logs
resource "aws_s3_bucket" "platform_artifact_logs" {
  bucket = "devops-platform-assessment-artifacts-logs-example"
}

# Block public access on log bucket
resource "aws_s3_bucket_public_access_block" "platform_artifact_logs" {
  bucket = aws_s3_bucket.platform_artifact_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Encrypt log bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "platform_artifact_logs" {
  bucket = aws_s3_bucket.platform_artifact_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# Allow S3 logging service to write access logs
resource "aws_s3_bucket_policy" "platform_artifact_logs" {
  bucket = aws_s3_bucket.platform_artifact_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowS3ServerAccessLogs"
        Effect = "Allow"
        Principal = {
          Service = "logging.s3.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.platform_artifact_logs.arn}/*"
        Condition = {
          ArnLike = {
            "aws:SourceArn" = aws_s3_bucket.platform_artifacts.arn
          }
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

# Enable access logging on artifact bucket
resource "aws_s3_bucket_logging" "platform_artifacts" {
  bucket = aws_s3_bucket.platform_artifacts.id

  target_bucket = aws_s3_bucket.platform_artifact_logs.id
  target_prefix = "artifact-access-logs/"
}

# Lifecycle rules
resource "aws_s3_bucket_lifecycle_configuration" "platform_artifacts" {
  bucket = aws_s3_bucket.platform_artifacts.id

  rule {
    id     = "artifact-retention"
    status = "Enabled"

    filter {}

    expiration {
      days = 90
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}
