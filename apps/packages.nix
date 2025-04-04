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
    xfce.ristretto
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
