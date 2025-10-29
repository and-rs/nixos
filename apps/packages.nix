{ pkgs, system, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    # terminal
    imagemagick
    fastfetch
    hyperfine
    ghostty
    cbonsai
    cmatrix
    ripgrep
    zoxide
    direnv
    rclone
    tokei
    unzip
    delta
    p7zip
    helix
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
    bc
    fd
    gh
    jq

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
    powertop
    pciutils
    thermald
    nautilus
    parted
    ffmpeg
    dunst
    mpv

    # apps
    inputs.zen-browser.packages."${system}".default
    google-chrome
    keepassxc
    obsidian
    vesktop

    obs-studio
    openh264
    x264
  ];
}
