{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    home-manager
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

    i3lock-color
    imagemagick
    playerctl
    xidlehook
    scrot

    brightnessctl
    pavucontrol
    polybarFull
    libnotify
    dunst
    xclip
    xsel
    rofi
    feh

    xfce.ristretto
    xfce.tumbler
    xfce.thunar

    ungoogled-chromium
    discord
  ];
}
