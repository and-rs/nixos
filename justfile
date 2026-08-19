# --- System Management ---

check-auth:
  aws sts get-caller-identity

gc:
  sudo nix-collect-garbage --delete-old
  sudo nix-store --gc

# --- nixos ---

nixos-switch:
  sudo nixos-rebuild switch --flake .#default

nixos-boot:
  sudo nixos-rebuild boot --flake .#default

# --- darwin ---

switch-darwin:
  sudo darwin-rebuild switch --flake .#M1

# --- amadeus ---

amadeus-install:
  #!/usr/bin/env bash
  set -euo pipefail
  sudo nix profile remove 0 >/dev/null 2>&1 || true
  sudo nix profile install .#amadeus --impure
  /nix/var/nix/profiles/default/bin/private-fonts-profile-watch-install

amadeus-upgrade:
  #!/usr/bin/env bash
  set -euo pipefail
  sudo nix profile upgrade 0 --impure
  /nix/var/nix/profiles/default/bin/private-fonts-profile-watch-install

# --- font ---

font-encrypt src name:
  #!/usr/bin/env bash
  set -euo pipefail
  mkdir -p secrets/fonts
  tmp="$(mktemp --suffix=.tar.gz)"
  trap 'rm -f "$tmp"' EXIT
  tar -C "$(dirname "{{src}}")" -czf "$tmp" "$(basename "{{src}}")"
  keys_expr='builtins.concatStringsSep "\n" ((import ./secrets/secrets.nix)."fonts/{{name}}.tar.gz.age".publicKeys)'
  keys="$(nix eval --impure --raw --expr "$keys_expr")"
  recipients=()
  while IFS= read -r k; do
    [ -n "$k" ] && recipients+=("-r" "$k")
  done <<< "$keys"
  age "${recipients[@]}" -o "secrets/fonts/{{name}}.tar.gz.age" "$tmp"

font-rekey:
  #!/usr/bin/env bash
  set -euo pipefail
  identity="${AGENIX_IDENTITY:-$HOME/.ssh/agenix}"
  for file in secrets/fonts/*.age; do
    rule="${file#secrets/}"
    keys_expr="builtins.concatStringsSep \"\\n\" ((import ./secrets/secrets.nix).\"$rule\".publicKeys)"
    keys="$(nix eval --impure --raw --expr "$keys_expr")"
    recipients=()
    while IFS= read -r key; do
      [ -n "$key" ] && recipients+=("-r" "$key")
    done <<< "$keys"

    tmp="$(mktemp --suffix=.age)"
    trap 'rm -f "$tmp"' EXIT
    age --decrypt --identity "$identity" "$file" | age "${recipients[@]}" --output "$tmp"
    mv "$tmp" "$file"
    trap - EXIT
  done

# --- Infrastructure ---

plan:
  terraform -chdir=infra plan

clean:
  terraform -chdir=infra destroy
