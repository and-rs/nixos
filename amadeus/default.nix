{ pkgs, inputs }:
let
  commonPackages =
    (import ../common/terminal.nix { inherit pkgs inputs; })
    ++ (import ../common/tooling.nix { inherit pkgs; });

  customQuickshell = import ./quickshell.nix { inherit pkgs; };
  hostIntegratedGoogleChrome = import ./google-chrome.nix { inherit pkgs; };
in
pkgs.symlinkJoin {
  name = "user-tools";

  paths = commonPackages ++ [
    (pkgs.azure-cli.override {
      withExtensions = [ pkgs.azure-cli-extensions.azure-devops ];
    })
    (pkgs.rofi.override { plugins = [ pkgs.rofi-calc ]; })

    pkgs.jujutsu
    pkgs.podman
    pkgs.terraform
    pkgs.snowflake-cli

    pkgs.slurp
    pkgs.ffmpeg
    pkgs.wf-recorder

    pkgs.awww
    pkgs.niri
    pkgs.grim
    pkgs.satty
    pkgs.xremap
    pkgs.hypridle
    pkgs.playerctl
    pkgs.pwvucontrol
    customQuickshell
    hostIntegratedGoogleChrome
    pkgs.xwayland-satellite
    pkgs.kdePackages.qtdeclarative
    pkgs.xdg-desktop-portal-gnome
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal
    pkgs.recursive
    pkgs.maple-mono.NL-TTF

    pkgs.uv
    pkgs.ty
    pkgs.ruff

    (pkgs.nixgl.nixGLCommon pkgs.nixgl.nixGLMesa)
  ];
}
