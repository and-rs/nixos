{ pkgs, inputs, ... }: {
  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    # desktop
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
    xsettingsd
    xorg.xprop
    xorg.xrdb
    powertop
    pciutils
    thermald
    nautilus
    nftables
    parted
    ffmpeg
    satty
    dunst
    mpv

    # apps
    inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
    helium-browser
    keepassxc
    hubstaff # fuck this shit
    obsidian
    winboat
    vesktop
    spotify

    obs-studio
    openh264
    obs-cmd
    x264
  ];
}
