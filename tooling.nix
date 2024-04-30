{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    bun
    yarn
    eslint_d
    prettierd
    nodePackages_latest.nodejs
    nodePackages_latest.eslint
    nodePackages_latest.prettier
    vscode-langservers-extracted
    tailwindcss-language-server
    nodePackages_latest.typescript-language-server
    typescript

    sumneko-lua-language-server
    stylua
    lua

    python3
    nodePackages_latest.pyright
    black
    mypy
    ruff

    shellcheck
    beautysh

    nixfmt-classic
    nil
    gcc

    neovide
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    package = pkgs.neovim-unwrapped;
  };
}
