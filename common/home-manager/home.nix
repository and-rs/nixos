{
  lib,
  inputs,
  isLinux,
  ...
}:
{
  imports = [
    inputs.agenix.homeManagerModules.default
    ./hetzner.nix
  ]
  ++ lib.optionals isLinux [
    ./cursor.nix
    ./dotfiles.nix
    ./aesthetics.nix
  ];

  home = {
    username = "and-rs";
    homeDirectory = if isLinux then "/home/and-rs" else "/Users/index/";
    stateVersion = if isLinux then "24.11" else "25.11";
  };

  programs.home-manager.enable = true;

  systemd.user.startServices = lib.mkIf isLinux "sd-switch";
}
