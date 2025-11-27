{ pkgs, ... }: {
  imports = [
    # shared packages
    ../modules/terminal.nix
    ../modules/tooling.nix
    ../modules/python.nix
    ./apps/terminal-macos.nix
  ];

  # will update when testing on macos
  environment.darwinConfig = "$HOME/Vault/personal/nixos/flake.nix";

  programs.direnv = {
    package = pkgs.direnv;
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };

  nix.package = pkgs.nix;
  nix.settings = {
    experimental-features = "nix-command flakes";
    download-buffer-size = 524288000;
  };

  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
