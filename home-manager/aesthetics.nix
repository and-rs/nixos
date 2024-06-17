{ pkgs, ... }: {
  fonts.fontconfig.enable = true;

  home.packages = [
    (pkgs.nerdfonts.override {
      fonts = [ "JetBrainsMono" "GeistMono" "Lilex" "ZedMono" "Recursive" ];
    })
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
}
