{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    bun
    deno
    biome
    nodejs_22
    rustywind
    corepack_latest
    pnpm-shell-completion
    nodePackages_latest.nodejs

    tailwindcss_4
    watchman

    prettierd
    typescript
    typescript-language-server
    nodePackages_latest.eslint
    nodePackages_latest.prettier
    vscode-langservers-extracted
    tailwindcss-language-server

    lua
    stylua
    lua-language-server
    luajitPackages.luarocks

    go
    gopls

    beautysh
    shellcheck
    bash-language-server

    gcc
    rustc
    cargo
    rustup
    rustfmt

    zls
    zig
    zig-shell-completions

    hurl
    curl

    tinymist
    typstyle
    typst

    qsv
    miller
    csvdiff
    csvlens

    docker_28
    docker-compose

    just
    cmake
    ninja
    gnumake
    pkg-config
    kdePackages.qt6ct
    kdePackages.qtbase
    kdePackages.qttools
    kdePackages.qtdeclarative

    nil
    sleek
    tree-sitter
    glsl_analyzer
    nixfmt-classic
    yaml-language-server
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  users.extraGroups.docker.members = [ "and-rs" ];
  virtualisation.docker = {
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
