terraform {
  required_providers { aws = { source = "hashicorp/aws", version = "~> 5.0" } }
  backend "s3" {
    bucket       = "nixed-terraform-state"
    key          = "nix-builder/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" { region = var.target_region }

variable "target_region" {
  type        = string
  description = "The AWS region for the Nix builder and cache resources"
}

variable "repo_url" {
  type        = string
  description = "The target flake URI for the ephemeral builder to compile"
}

variable "cache_bucket_name" {
  type        = string
  default     = "nixed-build-cache-bucket"
  description = "The S3 bucket name for storing the Nix binary cache"
}

variable "ssm_key_path" {
  type        = string
  default     = "/nix-builder/cache-signing-key"
  description = "The SSM parameter path containing the private cache signing key"
}

output "nix_cache_url" {
  value = "s3://${aws_s3_bucket.nix_cache.bucket}?region=${var.target_region}&priority=10"
}

output "builder_instance_id" {
  value = aws_instance.nix_builder.id
}
