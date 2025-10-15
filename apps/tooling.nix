{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    bun
    deno
    biome
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

    luajitPackages.luarocks
    lua-language-server
    stylua
    lua

    # I don't really know what these are but I need for numpy
    zlib
    stdenv.cc.cc.lib

    python313Packages.pip
    basedpyright
    virtualenv
    python313
    python312
    pyrefly
    djlint
    black
    zuban
    ruff
    uv
    ty

    go
    gopls

    bash-language-server
    shellcheck
    beautysh

    nixfmt-classic
    nil
    gcc

    rustc
    cargo
    rustup
    rustfmt

    zls
    zig
    zig-shell-completions

    postgres-lsp
    sleek

    glsl_analyzer
    hurl
    curl

    tinymist
    typstyle
    typst

    qsv
    millet
    csvdiff
    csvlens

    docker_28
    docker-compose
    tree-sitter
  ];

  environment.sessionVariables = {
    LD_LIBRARY_PATH = "${
        pkgs.lib.makeLibraryPath [ pkgs.zlib pkgs.stdenv.cc.cc.lib ]
      }:$LD_LIBRARY_PATH";
  };

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
