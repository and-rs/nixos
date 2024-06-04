{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    home-manager
    imagemagick
    alacritty
    keepassxc
    cbonsai
    ripgrep
    unzip
    delta
    p7zip
    btop
    tmux
    wget
    tldr
    git
    eza
    bat
    fzf
    zsh
    fd
    gh

    bunnyfetch
    fastfetch
    disfetch

    brightnessctl
    i3lock-color
    appimage-run
    pavucontrol
    polybarFull
    supergfxctl
    libnotify
    playerctl
    xidlehook
    powertop
    pciutils
    thermald
    scrot
    dunst
    xclip
    xsel
    rofi
    feh

    xfce.ristretto
    xfce.tumbler
    xfce.thunar
    mpv

    ungoogled-chromium
    obs-studio
    openh264
    discord
    x264
  ];
}
