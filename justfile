# --- System Management ---

switch-nixos:
    sudo nixos-rebuild switch --flake .#default

boot-nixos:
    sudo nixos-rebuild boot --flake .#default

switch-darwin:
    sudo darwin-rebuild switch --flake .#M1

gc:
    sudo nix-collect-garbage --delete-old
    sudo nix-store --gc

# --- Infrastructure ---

check-auth:
    aws sts get-caller-identity

plan:
    terraform -chdir=infra plan

deploy:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "> The remote builder compiles directly from your GitHub repository."
    read -p "Have you committed and pushed your latest changes? (yes/no): " ans
    if [ "$ans" != "yes" ]; then
        echo "Deployment aborted. Please push your changes first."
        exit 1
    fi
    terraform -chdir=infra init
    terraform -chdir=infra apply -auto-approve

# Live stream logs (only works while instance is running)
logs instance_id:
    aws ssm start-session \
        --target {{instance_id}} \
        --document-name AWS-StartInteractiveCommand \
        --parameters command="sudo tail -n 100 -f /tmp/builder.log"

# Fetch the final post-mortem log from S3 after the instance dies
logs-s3:
    aws s3 cp s3://nixed-build-cache-bucket/builder-logs.txt -

clean:
    terraform -chdir=infra destroy -target=aws_instance.nix_builder -auto-approve
