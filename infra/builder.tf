data "aws_ami" "nixos" {
  owners      = ["427812963091"]
  most_recent = true
  filter {
    name   = "name"
    values = ["nixos/25.11*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_security_group" "nix_builder" {
  name        = "nix-builder-sg"
  description = "Egress only, SSM manages access"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nix_builder" {
  ami                                  = data.aws_ami.nixos.id
  instance_type                        = "m6a.8xlarge"
  instance_initiated_shutdown_behavior = "terminate"
  iam_instance_profile                 = aws_iam_instance_profile.nix_builder.name
  vpc_security_group_ids               = [aws_security_group.nix_builder.id]

  root_block_device {
    volume_size = 200
    volume_type = "gp3"
    iops        = 8000
    throughput  = 1000
  }

  user_data = templatefile("${path.module}/scripts/build.sh", {
    region    = var.target_region
    s3_bucket = aws_s3_bucket.nix_cache.bucket
    ssm_key   = var.ssm_key_path
    repo_url  = var.repo_url
  })
}
