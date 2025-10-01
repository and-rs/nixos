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
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_ENABLE_HIGHDPI_SCALING = "1";
    QT_SCREEN_SCALE_FACTORS = "1";
    QT_WAYLAND_FORCE_DPI = "120";
    QT_QPA_PLATFORM = "wayland";
    LIBVA_DRIVER_NAME = "iHD";

    WLR_NO_HARDWARE_CURSORS = "1";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    (rofi.override { plugins = [ rofi-calc ]; })
    # kdePackages.xwaylandvideobridge
    xwayland-satellite
    wl-clipboard
    xwayland
    waybar
    swww
  ];
}
