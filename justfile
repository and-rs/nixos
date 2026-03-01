check-auth:
    aws sts get-caller-identity

deploy:
    terraform -chdir=infra init
    terraform -chdir=infra apply

logs instance_id:
    aws ssm start-session \
        --target {{instance_id}} \
        --document-name AWS-StartInteractiveCommand \
        --parameters command="journalctl -u cloud-init-output.service -f"

clean:
    terraform -chdir=infra destroy -target=aws_spot_instance_request.nix_builder
