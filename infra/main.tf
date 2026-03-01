terraform {
  required_providers { aws = { source = "hashicorp/aws", version = "~> 5.0" } }
}

provider "aws" { region = var.target_region }

variable "target_region" { default = "us-west-2" }
variable "cache_bucket_name" { default = "and-rs-nix-cache-bucket-123" } # Ensure global uniqueness
variable "ssm_key_path" { default = "/nix-builder/cache-signing-key" }
variable "repo_url" { default = "github:and-rs/nixos" } # Must be public

output "nix_cache_url" {
  value = "s3://${aws_s3_bucket.nix_cache.bucket}?region=${var.target_region}&priority=10"
}

output "nix_cache_public_key" {
  value = trimspace(file("${path.module}/cache-public.pem"))
}

output "builder_instance_id" {
  value = aws_spot_instance_request.nix_builder.spot_instance_id
}
