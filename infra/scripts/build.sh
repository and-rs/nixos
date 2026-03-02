#!/usr/bin/env bash
set -euo pipefail

# --- TERRAFORM INJECTIONS ---
TARGET_REGION="${region}"
SSM_KEY_PATH="${ssm_key}"
S3_BUCKET="${s3_bucket}"
REPO_URL="${repo_url}"
# ----------------------------

LOG_FILE="/tmp/builder.log"
exec > >(tee -a "$LOG_FILE") 2>&1

function exfiltrate_and_die() {
    EXIT_CODE=$?
    echo "Exiting with code $EXIT_CODE. Pushing logs to S3..."
    nix run --accept-flake-config nixpkgs#awscli2 -- s3 cp "$LOG_FILE" "s3://$S3_BUCKET/builder-logs.txt" --region "$TARGET_REGION" || true
    shutdown -h now
}
trap exfiltrate_and_die EXIT

export NIX_CONFIG="experimental-features = nix-command flakes"

echo "Starting ephemeral NixOS build..."
SECRET_KEY=""
MAX_RETRIES=5

for ((i=1; i<=MAX_RETRIES; i++)); do
    echo "Fetching SSM key (Attempt $i/$MAX_RETRIES)..."
    if SECRET_KEY=$(nix run --accept-flake-config nixpkgs#awscli2 -- ssm get-parameter \
            --region "$TARGET_REGION" \
            --name "$SSM_KEY_PATH" \
            --with-decryption \
            --query "Parameter.Value" \
            --output text); then
        echo "Successfully retrieved signing key."
        break
    else
        echo "Failed. Retrying in 10s..."
        sleep 10
    fi
done

if [ -z "$SECRET_KEY" ]; then
    echo "FATAL: Failed to retrieve cache signing key."
    exit 1
fi

echo "$SECRET_KEY" > /root/cache-key.pem
chmod 400 /root/cache-key.pem

TARGET="#nixosConfigurations.default.config.system.build.toplevel"

echo "Evaluating flake..."
nix build "$REPO_URL$TARGET" --no-link --max-jobs 2 --cores 8

echo "Pushing cache..."
nix copy "$REPO_URL$TARGET" \
    --to "s3://$S3_BUCKET?region=$TARGET_REGION&secret-key=/root/cache-key.pem"

echo "Success."
