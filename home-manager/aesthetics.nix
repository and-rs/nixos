{ pkgs, inputs, ... }: {
  nixpkgs.config.input-fonts.acceptLicense = true;
  fonts.fontconfig.enable = true;

  home.packages = [
    pkgs.nerd-fonts.symbols-only
    pkgs.material-symbols
    pkgs.input-fonts
    pkgs.ibm-plex

    (pkgs.epapirus-icon-theme.override { color = "grey"; })
    (pkgs.colloid-gtk-theme.override {
      colorVariants = [ "dark" ];
      themeVariants = [ "grey" ];
      tweaks = [ "black" "float" "rimless" ];
    })
  ];

  home.pointerCursor = {
    package = pkgs.apple-cursor;
    name = "nix_macOS";
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = "macOS";
    };
  };

  gtk = {
    enable = true;
    font = {
      name = "IBM Plex Sans";
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
