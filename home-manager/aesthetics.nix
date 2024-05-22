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

  services.picom = {
    enable = true;
    vSync = true;
    backend = "egl";
    shadow = true;
    fade = true;
    fadeDelta = 3;
    inactiveOpacity = 0.8;
    shadowExclude = [
      "class_g *?= 'polybar'"
      "class_g *?= 'i3-frame'"
      "window_type = 'menu'"
      "window_type = 'dropdown_menu'"
      "window_type = 'popup_menu'"
      "window_type = 'tooltip'"
    ];
    opacityRules = [
      "100:class_g *?= 'rofi'"
      "100:class_g *?= 'firefox'"
      "100:class_g *?= 'i3-frame'"
    ];
    settings = {
      corner-radius = 12;
      blur = {
        method = "dual_kawase";
        size = 10;
        deviation = 5.0;
      };
      blur-background-exclude = [
        "window_type = 'menu'"
        "window_type = 'dropdown_menu'"
        "window_type = 'popup_menu'"
        "window_type = 'tooltip'"
        "class_g *?= 'i3-frame'"
      ];
    };
  };
}
