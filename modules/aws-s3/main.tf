# S3 bucket để lưu trữ source code
resource "aws_s3_bucket" "source_bucket" {
  bucket = "${var.project_name}-s3"

  tags = merge(var.tags, {
    Name = "${var.project_name}-s3"
  })
}

# Enable versioning cho S3 bucket
resource "aws_s3_bucket_versioning" "source_bucket_versioning" {
  bucket = aws_s3_bucket.source_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Block public access cho S3 bucket
resource "aws_s3_bucket_public_access_block" "source_bucket_pab" {
  bucket = aws_s3_bucket.source_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 bucket cho CodePipeline artifacts
resource "aws_s3_bucket" "codepipeline_artifacts" {
  bucket = "${var.project_name}-codepipeline-artifacts"

  tags = merge(var.tags, {
    Name = "${var.project_name}-codepipeline-artifacts"
  })
}

# Enable versioning cho CodePipeline artifacts bucket
resource "aws_s3_bucket_versioning" "codepipeline_artifacts_versioning" {
  bucket = aws_s3_bucket.codepipeline_artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Block public access cho CodePipeline artifacts bucket
resource "aws_s3_bucket_public_access_block" "codepipeline_artifacts_pab" {
  bucket = aws_s3_bucket.codepipeline_artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 bucket notification cho CodePipeline trigger
resource "aws_s3_bucket_notification" "source_bucket_notification" {
  count  = var.enable_s3_notification ? 1 : 0
  bucket = aws_s3_bucket.source_bucket.id

  eventbridge = true
}
