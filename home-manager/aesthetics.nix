{ pkgs, inputs, ... }: {
  nixpkgs.config.input-fonts.acceptLicense = true;
  fonts.fontconfig.enable = true;

  home.packages = [
    pkgs.nerd-fonts.symbols-only
    pkgs.material-symbols
    pkgs.input-fonts
    pkgs.inter

    (pkgs.epapirus-icon-theme.override { color = "grey"; })
    (pkgs.colloid-gtk-theme.override {
      colorVariants = [ "dark" ];
      themeVariants = [ "grey" ];
      tweaks = [ "black" "float" "rimless" ];
    })
  ];

  home.pointerCursor = {
    gtk.enable = true;
    name = "macOS-Monterey";
    package = pkgs.apple-cursor;
    size = 32;
  };

  gtk = {
    enable = true;
    font = {
      name = "Inter";
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
