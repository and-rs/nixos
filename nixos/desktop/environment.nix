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

  services.hypridle.enable = true;
  programs.hyprlock.enable = true;
  programs.niri.enable = true;
  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    LIBVA_DRIVER_NAME = "iHD";
    NIXOS_OZONE_WL = "1";
  };

  programs.dconf.profiles.user = {
    databases = [{
      lockAll = true;
      settings = {
        "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
      };
    }];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    (rofi.override { plugins = [ rofi-calc ]; })
    libqalculate # required for rofi-calc

    xwayland-satellite
    wl-clipboard
    quickshell
    xwayland
    swww
  ];
}
