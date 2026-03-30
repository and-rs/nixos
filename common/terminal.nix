{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages."${stdenv.hostPlatform.system}".default
    bob-nvim

    yek
    mdcat
    aichat

    fzf
    tmux
    direnv
    zoxide
    oh-my-posh

    nufmt
    nushell
    topiary
    carapace

    age
    grit
    sqlite
    sqldiff

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
