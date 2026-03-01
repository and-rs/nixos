{ inputs, ... }:
{
  imports = [
    ./cursor.nix
    ./dotfiles.nix
    ./aesthetics.nix
  ];

  programs.home-manager.enable = true;

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "and-rs";
    homeDirectory = "/home/and-rs";
    stateVersion = "24.11";
  };

  systemd.user.startServices = "sd-switch";
}
