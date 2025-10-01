{ pkgs, inputs, ... }: {
  nixpkgs.config.input-fonts.acceptLicense = true;
  fonts.fontconfig.enable = true;

  home.packages = [
    pkgs.nerd-fonts.symbols-only
    pkgs.material-symbols
    pkgs.input-fonts
    pkgs.recursive
    pkgs.ibm-plex

    pkgs.papirus-icon-theme
    pkgs.papirus-folders

    (pkgs.colloid-gtk-theme.override {
      colorVariants = [ "dark" ];
      themeVariants = [ "grey" ];
      tweaks = [ "black" ];
    })
  ];

  home.sessionVariables.GTK_THEME = "Colloid-Grey-Dark";

  gtk = {
    enable = true;
    font = {
      name = "IBM Plex Sans";
      size = 10;
    };
    theme = { name = "Colloid-Grey-Dark"; };
    iconTheme = { name = "Papirus-Dark"; };
  };

  home.pointerCursor = {
    package = pkgs.apple-cursor;
    gtk.enable = true;
    name = "macOS";
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = "macOS";
    };
  };

  qt = { enable = true; };

  programs.spicetify =
    let spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in {
      enable = true;
      theme = spicePkgs.themes.text;
      # colorScheme = "Mono";

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        shuffle
        hidePodcasts
      ];
    };
}
