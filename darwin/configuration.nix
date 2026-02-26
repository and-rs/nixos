{ pkgs, ... }: {
  imports =
    [ ./apps/terminal-macos.nix ./apps/yt-dlp.nix ./networking/blocklist.nix ];

  programs.direnv = {
    package = pkgs.direnv;
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };

  nix.package = pkgs.nix;
  environment.darwinConfig = "$HOME/Vault/personal/nixos/flake.nix";

  nixpkgs.config.allowBroken = true; # grit is marked as broken in darwin

  system.stateVersion = 4;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
