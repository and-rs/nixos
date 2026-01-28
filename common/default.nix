{
  imports = [
    ../common/terminal.nix
    ../common/tooling.nix
    ../common/python.nix
  ];

  nix.optimise.automatic = true;
  nix.settings.warn-dirty = false;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;
}
