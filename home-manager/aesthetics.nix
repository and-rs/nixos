{ pkgs, inputs, ... }: {
  nixpkgs.config.input-fonts.acceptLicense = true;
  fonts.fontconfig.enable = true;

  home.packages = [
    pkgs.nerd-fonts.symbols-only
    pkgs.material-symbols
    pkgs.input-fonts
    pkgs.work-sans
    pkgs.inter

    (pkgs.epapirus-icon-theme.override { color = "grey"; })
    (pkgs.colloid-gtk-theme.override {
      colorVariants = [ "dark" ];
      themeVariants = [ "grey" ];
      tweaks = [ "black" "float" "rimless" ];
    })
  ];

  # home.pointerCursor = {
  #   x11.enable = true;
  #   gtk.enable = true;
  #   name = "macOS1";
  #   package = pkgs.apple-cursor;
  #   size = 24;
  # };

  gtk = {
    enable = true;
    font = {
      name = "Work Sans";
      size = 10;
    };
    theme = { name = "Colloid-Grey-Dark"; };
    iconTheme = { name = "ePapirus-Dark"; };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  programs.spicetify =
    let spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in {
      enable = true;
      theme = spicePkgs.themes.comfy;
      colorScheme = "mono";

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        shuffle
        hidePodcasts
      ];
    };
}
