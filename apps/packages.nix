{ pkgs, system, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    imagemagick
    fastfetch
    ghostty
    cbonsai
    cmatrix
    ripgrep
    direnv
    tokei
    kitty
    unzip
    delta
    p7zip
    yazi
    btop
    stow
    tmux
    wget
    tldr
    glab
    git
    eza
    bat
    fzf
    zsh
    fd
    gh
    jq

    networkmanagerapplet
    wpa_supplicant_gui

    xfce.ristretto
    inotify-tools
    brightnessctl
    appimage-run
    home-manager
    pavucontrol
    alsa-utils
    libnotify
    playerctl
    powertop
    pciutils
    thermald
    nautilus
    dunst
    mpv

    inputs.zen-browser.packages."${system}".default
    google-chrome
    obs-studio
    keepassxc
    openh264
    vesktop
    x264
  ];
}
