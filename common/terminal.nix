{ pkgs, inputs }:
with pkgs;
[
  inputs.agenix.packages.${stdenv.hostPlatform.system}.default
  bob-nvim
  chezmoi
  helix

  yek
  opencode

  fzf
  skim
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
  git
  eza
  fd
  gh
  jq
]
