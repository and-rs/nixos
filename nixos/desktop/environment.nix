{ pkgs, ... }:
let
  disableDBus =
    pkg:
    pkg.overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
        for file in $out/share/applications/*.desktop; do
          substituteInPlace "$file" \
            --replace "DBusActivatable=true" "DBusActivatable=false"
        done
      '';
    });
in
{
  services.dbus.implementation = "broker";
  services.gnome.tinysparql.enable = true;
  services.gnome.localsearch.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      niri = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
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
    (disableDBus pkgs.nautilus)
    (disableDBus pkgs.loupe)

    (rofi.override { plugins = [ rofi-calc ]; })
    libqalculate

    xwayland-satellite
    wl-clipboard
    wf-recorder
    quickshell
    xwayland
    hypridle
    upower
    slurp
    grim
    swww
  ];
}
