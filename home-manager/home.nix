{ pkgs, ... }: {
  imports = [ ./aesthetics.nix ];

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userEmail = "deserd@protonmail.com";
    userName = "JuanBaut";
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home.packages = [
    (pkgs.nerdfonts.override {
      fonts = [ "JetBrainsMono" "GeistMono" "Lilex" "ZedMono" "Recursive" ];
    })
    pkgs.inter
    pkgs.whitesur-icon-theme
    (pkgs.whitesur-gtk-theme.override {
      colorVariants = [ "Dark" ];
      themeVariants = [ "grey" ];
    })
  ];

  home = {
    username = "dagger";
    homeDirectory = "/home/dagger";
    stateVersion = "23.11";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
