{ pkgs, ... }:
let
  apps = with pkgs; [
    obs-studio
    obs-cmd

    helium-browser
    firefox

    keepassxc
    obsidian
    winboat
    vesktop
    zathura
    spotify
  ];

  system = with pkgs; [
    inotify-tools
    brightnessctl
    appimage-run
    home-manager
    pavucontrol
    efibootmgr
    alsa-utils
    libnotify
    blueberry
    playerctl
    xorg.xrdb
    powertop
    thermald
    pciutils
    nftables
    parted
    satty
    mpv
    dig
  ];

  codecs = with pkgs; [
    openh264
    ffmpeg
    x264
  ];
in
{
  environment.systemPackages = apps ++ codecs ++ system;
}
