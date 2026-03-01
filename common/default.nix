{
  imports = [
    ../common/terminal.nix
    ../common/tooling.nix
    ../common/python.nix
  ];

  nix.settings.warn-dirty = false;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    download-buffer-size = 1 * 1024 * 1024 * 1024;
  };

  nix.settings = {
    auto-optimise-store = true;
  };
}
