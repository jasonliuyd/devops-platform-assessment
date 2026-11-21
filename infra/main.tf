# ============================================================
# Main Artifact Bucket
# ============================================================

resource "aws_s3_bucket" "platform_artifacts" {

  #checkov:skip=CKV_AWS_144:Cross-region replication is deferred until a production DR region is defined.
  #checkov:skip=CKV2_AWS_62:Artifact event notifications are not required for this assessment example.

  bucket = "devops-platform-assessment-artifacts-example"

  lifecycle {
    prevent_destroy = true
  }
}

# ============================================================
# Artifact Bucket Versioning
# ============================================================

resource "aws_s3_bucket_versioning" "platform_artifacts" {
  bucket = aws_s3_bucket.platform_artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ============================================================
# Artifact Bucket Public Access Protection
# ============================================================

resource "aws_s3_bucket_public_access_block" "platform_artifacts" {
  bucket = aws_s3_bucket.platform_artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ============================================================
# Artifact Bucket Encryption
# ============================================================

resource "aws_s3_bucket_server_side_encryption_configuration" "platform_artifacts" {
  bucket = aws_s3_bucket.platform_artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

# ============================================================
# Separate Access Log Bucket
# ============================================================

resource "aws_s3_bucket" "platform_artifact_logs" {

  #checkov:skip=CKV_AWS_144:Cross-region replication is deferred until a production DR region is defined.
  #checkov:skip=CKV2_AWS_62:Log delivery event notifications are not required for this assessment example.

  bucket = "devops-platform-assessment-artifacts-logs-example"
}

# ============================================================
# Log Bucket Versioning
# ============================================================

resource "aws_s3_bucket_versioning" "platform_artifact_logs" {
  bucket = aws_s3_bucket.platform_artifact_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ============================================================
# Log Bucket Public Access Protection
# ============================================================

resource "aws_s3_bucket_public_access_block" "platform_artifact_logs" {
  bucket = aws_s3_bucket.platform_artifact_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ============================================================
# Log Bucket Encryption
# ============================================================

resource "aws_s3_bucket_server_side_encryption_configuration" "platform_artifact_logs" {
  bucket = aws_s3_bucket.platform_artifact_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

# ============================================================
# Log Bucket Lifecycle
# ============================================================

resource "aws_s3_bucket_lifecycle_configuration" "platform_artifact_logs" {
  bucket = aws_s3_bucket.platform_artifact_logs.id

  rule {
    id     = "access-log-retention"
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

# ============================================================
# Current AWS Account Identity
# ============================================================

data "aws_caller_identity" "current" {}

# ============================================================
# Allow S3 Server Access Logging to Write into Log Bucket
# ============================================================

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

# ============================================================
# Enable Access Logging on Artifact Bucket
# ============================================================

resource "aws_s3_bucket_logging" "platform_artifacts" {
  bucket = aws_s3_bucket.platform_artifacts.id

  target_bucket = aws_s3_bucket.platform_artifact_logs.id
  target_prefix = "artifact-access-logs/"
}

# ============================================================
# Artifact Bucket Lifecycle
# ============================================================

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
