{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    imagemagick
    alacritty
    cbonsai
    ripgrep
    helix
    unzip
    delta
    p7zip
    btop
    stow
    tmux
    wget
    tldr
    git
    eza
    bat
    fzf
    zsh
    nnn
    fd
    gh
    jq

    bunnyfetch
    fastfetch
    disfetch

    networkmanagerapplet
    inotify-tools
    brightnessctl
    appimage-run
    home-manager
    pavucontrol
    supergfxctl
    libnotify
    playerctl
    powertop
    pciutils
    thermald
    psensor
    dunst
    feh

    xfce.ristretto
    xfce.tumbler
    xfce.thunar
    mpv

    firefox-devedition
    obs-studio
    keepassxc
    openh264
    discord
    vesktop
    x264
  ];
}
