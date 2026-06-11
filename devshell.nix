{ pkgs }:
pkgs.mkShell {
  packages = with pkgs; [
    ssm-session-manager-plugin
    terraform
    awscli2
    just
  ];

  shellHook = ''
    export REGION="us-west-2"
    export REPO_URL="github:and-rs/nixed"

    export TF_VAR_repo_url="$REPO_URL"
    export TF_VAR_target_region="$REGION"

    export AWS_DEFAULT_REGION="$REGION"
    export AWS_REGION="$REGION"

    aws configure set profile.nix-dev.region "$REGION"
    aws configure set profile.nix-dev.credential_process "aws configure export-credentials --profile default --format process"
    export AWS_PROFILE="nix-dev"
  '';
}
