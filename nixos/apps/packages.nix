{ pkgs, inputs, ... }:
let
  apps = with pkgs; [
    obs-studio
    obs-cmd
    inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
    helium-browser
    keepassxc
    obsidian
    hubstaff
    winboat
    vesktop
    zathura
    spotify
    loupe
  ];

  system = with pkgs; [
    inotify-tools
    brightnessctl
    appimage-run
    home-manager
    pavucontrol
    efibootmgr
    alsa-utils
    cabextract
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
  services.flatpak.enable = true;
  environment.systemPackages = apps ++ codecs ++ system;
}
