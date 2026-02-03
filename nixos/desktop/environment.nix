{ pkgs, ... }:
{
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gnome
    ];
  };

  services.upower.enable = true;
  programs = {
    niri.useNautilus = true;
    hyprlock.enable = true;
    niri.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };

  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    LIBVA_DRIVER_NAME = "iHD";
    NIXOS_OZONE_WL = "1";
  };

  programs.dconf.profiles.user = {
    databases = [
      {
        lockAll = true;
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    (rofi.override { plugins = [ rofi-calc ]; })
    libqalculate # required for rofi-calc

    xwayland-satellite
    wl-clipboard
    wf-recorder
    quickshell
    xwayland
    hypridle
    nautilus
    upower
    slurp
    grim
    swww
  ];
}
