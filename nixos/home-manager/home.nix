{ inputs, ... }:
{
  imports = [
    inputs.agenix.homeManagerModules.default
    ./cursor.nix
    ./hetzner.nix
    ./dotfiles.nix
    ./aesthetics.nix
  ];

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
