{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    yek
    argc
    aichat

    fzf
    tmux
    direnv
    zoxide
    oh-my-posh

    fish
    fish-lsp

    nufmt
    nushell

    age
    grit

    imagemagick
    fastfetch
    hyperfine
    alacritty
    cbonsai
    neovide
    cmatrix
    ripgrep
    slides
    dotbot
    broot
    tokei
    unzip
    delta
    p7zip
    kitty
    yazi
    btop
    wget
    nmap
    tldr
    git
    eza
    bat
    fd
    gh
    jq
  ];
}
