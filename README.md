# My NixOS + Nix Darwin flake setup.

## Structure

1. `./modules`
   - Shared modules between the two hosts, with the exact same tooling and terminal packages.

2. `./darwin`
   - Super simple nix-darwin setup for reproducible packages.

3. `./nixos`
   - Somewhat complex setup for nixos with `CachyOS kernel`, `wayland`, `niri`, etc.
