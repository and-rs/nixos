{ pkgs, inputs, ... }: {
  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    # desktop
    inotify-tools
    brightnessctl
    appimage-run
    home-manager
    pavucontrol
    efibootmgr
    alsa-utils
    ristretto
    blueberry
    libnotify
    playerctl
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
    dig
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

    cabextract

    obs-studio
    openh264
    obs-cmd
    x264
  ];
}
