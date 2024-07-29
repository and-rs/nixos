{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    bun
    yarn
    corepack_latest
    pnpm-shell-completion
    nodePackages_latest.nodejs

    emmet-ls
    prettierd
    typescript
    nodePackages_latest.eslint
    nodePackages_latest.prettier
    vscode-langservers-extracted
    tailwindcss-language-server
    nodePackages_latest.typescript-language-server
    nodePackages_latest.vscode-json-languageserver

    sumneko-lua-language-server
    luajitPackages.luarocks
    stylua
    lua

    python312Packages.pip
    basedpyright
    python3Full
    virtualenv
    ruff-lsp
    black
    pdm

    go
    gopls

    shellcheck
    beautysh

    nixfmt-classic
    nil
    gcc

    zig-shell-completions
    zig
    zls

    neovide
    insomnia

    docker_27
    docker-compose
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  virtualisation.docker = {
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
