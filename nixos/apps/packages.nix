{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    # desktop
    networkmanagerapplet
    xfce.ristretto
    inotify-tools
    brightnessctl
    appimage-run
    home-manager
    pavucontrol
    efibootmgr
    alsa-utils
    blueberry
    libnotify
    playerctl
    xorg.xrdb
    powertop
    pciutils
    thermald
    nautilus
    parted
    ffmpeg
    satty
    dunst
    mpv

    # apps
    inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
    google-chrome
    keepassxc
    obsidian
    winboat
    vesktop
    spotify

    obs-studio
    obs-cmd
    openh264
    x264
  ];
}
