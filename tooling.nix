{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    bun
    yarn
    prettierd
    pnpm-shell-completion
    nodePackages_latest.pnpm
    nodePackages_latest.nodejs
    nodePackages_latest.eslint
    nodePackages_latest.prettier
    vscode-langservers-extracted
    tailwindcss-language-server
    nodePackages_latest.typescript-language-server
    nodePackages_latest.vscode-json-languageserver
    typescript
    emmet-ls

    sumneko-lua-language-server
    stylua
    lua

    python3
    pyright
    black
    mypy
    ruff

    shellcheck
    beautysh

    nixfmt-classic
    nil
    gcc

    zig-shell-completions
    zig
    zls

    neovide
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    package = pkgs.neovim-unwrapped;
  };
}
