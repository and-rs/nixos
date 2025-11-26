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
    broot
    tokei
    unzip
    delta
    p7zip
    helix
    file
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
    xorg.xrdb
    powertop
    pciutils
    thermald
    nautilus
    parted
    ffmpeg
    satty
    dunst
    mpv

    # apps
    inputs.zen-browser.packages."${system}".default
    google-chrome
    keepassxc
    obsidian
    winboat
    vesktop
    spotify

    obs-studio
    obs-cmd
    openh264
    x264
  ];
}
