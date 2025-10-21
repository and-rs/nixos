{ pkgs, ... }: {
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gnome
    ];
  };

  programs.hyprlock.enable = true;
  nixpkgs.config.input-fonts.acceptLicense = true;

  fonts = {
    packages = with pkgs; [ input-fonts recursive hanken-grotesk ];
    fontconfig = {
      enable = true;
      antialias = true;
      subpixel.lcdfilter = "none";
      hinting = {
        enable = true;
        autohint = true;
        # style = "none";
      };
      defaultFonts = {
        monospace = [ "Input Mono" ];
        sansSerif = [ "Hanken Grotesk" ];
        serif = [ "Hanken Grotesk" ];
      };
    };
  };

  programs.dconf.profiles.user = {
    databases = [{
      lockAll = true;
      settings = {
        "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
      };
    }];
  };

  programs.niri.enable = true;

  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    LIBVA_DRIVER_NAME = "iHD";
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    (rofi.override { plugins = [ rofi-calc ]; })
    xwayland-satellite
    wl-clipboard
    swayidle
    xwayland
    waybar
    swww
  ];
}
