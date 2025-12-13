{
  imports = [
    ../common/bun-overlay.nix
    ../common/terminal.nix
    ../common/tooling.nix
    ../common/python.nix
  ];

  nix.settings.warn-dirty = false;
  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
}
