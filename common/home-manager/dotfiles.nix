{ pkgs, ... }:
let
  home = "/home/and-rs";
  neovimRepo = "https://github.com/and-rs/nvim.git";
  dotfilesRepo = "https://github.com/and-rs/dotfiles.git";

  neovimPath = "${home}/Vault/personal/nvim";
  dotfilesPath = "${home}/Vault/personal/dotfiles";
in
{
  home.activation.dotfiles-setup = ''
    ${pkgs.bash}/bin/bash -c '
      if [ ! -d "${dotfilesPath}/.git" ]; then
        ${pkgs.git}/bin/git clone ${dotfilesRepo} ${dotfilesPath}
      fi

      if [ ! -d "${neovimPath}/.git" ]; then
        ${pkgs.git}/bin/git clone ${neovimRepo} ${neovimPath}
        ln -s ${neovimPath} $HOME/.config
      fi
    '
  '';
}
