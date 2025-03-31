{ pkgs, system, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    imagemagick
    ghostty
    cbonsai
    ripgrep
    direnv
    kitty
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
    alsa-utils
    libnotify
    playerctl
    powertop
    pciutils
    thermald
    dunst
    feh

    xfce.ristretto
    xfce.tumbler
    xfce.thunar
    mpv

    inputs.zen-browser.packages."${system}".default
    google-chrome
    obs-studio
    keepassxc
    openh264
    vesktop
    discord
    x264
  ];
}
