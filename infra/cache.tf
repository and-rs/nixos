resource "aws_s3_bucket" "nix_cache" {
  bucket = var.cache_bucket_name
  lifecycle { prevent_destroy = true }
}

resource "aws_s3_bucket_versioning" "nix_cache" {
  bucket = aws_s3_bucket.nix_cache.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_public_access_block" "nix_cache" {
  bucket                  = aws_s3_bucket.nix_cache.id
  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "nix_cache_read" {
  bucket = aws_s3_bucket.nix_cache.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.nix_cache.arn}/*"
    }]
  })
  depends_on = [aws_s3_bucket_public_access_block.nix_cache]
}
