{ pkgs, ... }: {
  imports = [
    ../modules/terminal.nix
    ../modules/tooling.nix
    ../modules/python.nix
    ./apps/terminal-macos.nix
  ];

  programs.direnv = {
    package = pkgs.direnv;
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };

  nix.package = pkgs.nix;
  nix.settings = { experimental-features = "nix-command flakes"; };
  environment.darwinConfig = "$HOME/Vault/personal/nixos/flake.nix";

  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
