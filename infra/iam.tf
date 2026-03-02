data "aws_caller_identity" "current" {}

resource "aws_iam_role" "nix_builder" {
  name = "nix-builder-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "ec2.amazonaws.com" } }]
  })
}

resource "aws_iam_policy" "nix_builder_policy" {
  name = "nix-builder-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject", "s3:GetBucketLocation", "s3:ListBucket",
          "s3:ListBucketMultipartUploads", "s3:AbortMultipartUpload", "s3:ListMultipartUploadParts"
        ]
        Resource = [aws_s3_bucket.nix_cache.arn, "${aws_s3_bucket.nix_cache.arn}/*"]
      },
      {
        Effect   = "Allow"
        Action   = "ssm:GetParameter"
        Resource = "arn:aws:ssm:${var.target_region}:${data.aws_caller_identity.current.account_id}:parameter/${trimprefix(var.ssm_key_path, "/")}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "nix_builder_attach" {
  role       = aws_iam_role.nix_builder.name
  policy_arn = aws_iam_policy.nix_builder_policy.arn
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.nix_builder.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "nix_builder" {
  name = "nix-builder-profile"
  role = aws_iam_role.nix_builder.name
}
