{ pkgs, ... }: {

  fonts.fontconfig.enable = true;

  home.pointerCursor = {
    name = "macOS-Monterey";
    package = pkgs.apple-cursor;
    size = 32;
  };

  gtk = {
    enable = true;
    font = {
      name = "ZedMono Nerd Font Propo";
      size = 10;
      package = pkgs.work-sans;
    };
    theme = {
      name = "Colloid-Dark";
      package = pkgs.colloid-gtk-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  services.picom = {
    enable = true;
    vSync = true;
    backend = "glx";
    shadow = true;
    fade = true;
    fadeDelta = 3;
    inactiveOpacity = 0.8;
    shadowExclude = [ "class_g *?= 'polybar'" ];
    opacityRules = [ "100:class_g *?= 'rofi'" "100:class_g *?= 'firefox'" ];
    settings = {
      corner-radius = 12;
      blur = {
        method = "dual_kawase";
        size = 10;
        deviation = 5.0;
      };
    };
  };
}
