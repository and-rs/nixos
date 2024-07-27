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

    python3
    pyright
    black
    mypy
    ruff

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
    postgresql

    docker
    docker-compose
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "dagger" ];
}
