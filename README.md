# My NixOS + Nix Darwin flake setup.

## Structure

1. `./common`
   - Shared common between the two hosts, with the exact same tooling and terminal packages.

2. `./darwin`
   - Super simple nix-darwin setup for reproducible packages.

3. `./nixos`
   - Somewhat complex setup for nixos with `CachyOS kernel`, `wayland`, `niri`, etc.

## Private fonts

Private font archives remain encrypted under `secrets/fonts`. Home Manager decrypts and
atomically synchronizes the active set during activation. The Amadeus profile installs a
user-level path watcher which performs the same synchronization whenever the root Nix
profile changes, including removal of fonts when the profile no longer contains them.
