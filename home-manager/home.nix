{ inputs, ... }: {
  imports = [
    ./cursor.nix
    ./aesthetics.nix
    inputs.spicetify-nix.homeManagerModules.default
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

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
