{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    home-manager
    imagemagick
    alacritty
    keepassxc
    fastfetch
    neofetch
    cbonsai
    ripgrep
    unzip
    btop
    tmux
    wget
    tldr
    git
    eza
    fzf
    zsh
    fd

    brightnessctl
    i3lock-color
    appimage-run
    libva-utils
    pavucontrol
    polybarFull
    supergfxctl
    libnotify
    playerctl
    xidlehook
    powertop
    pciutils
    scrot
    dunst
    xclip
    xsel
    rofi
    feh

    xfce.ristretto
    xfce.tumbler
    xfce.thunar

    ungoogled-chromium
    firefox-devedition
    discord
  ];
}
