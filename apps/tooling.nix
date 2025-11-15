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

    # I don't really know what these are but I need for numpy
    zlib
    libcxx.dev
    stdenv.cc.cc.lib
    stdenv.cc
    stdenv

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

  environment.sessionVariables = {
    CC = "${pkgs.stdenv.cc}/bin/gcc";
    AR = "${pkgs.stdenv.cc.bintools}/bin/ar";
    CFLAGS = "-O2 -D_GNU_SOURCE";
    CXXFLAGS = "-O2 -D_GNU_SOURCE";
    LD_LIBRARY_PATH = "${
        pkgs.lib.makeLibraryPath [ pkgs.zlib pkgs.stdenv.cc.cc.lib ]
      }:$LD_LIBRARY_PATH";
  };

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
