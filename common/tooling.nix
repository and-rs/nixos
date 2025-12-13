{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    bun
    deno
    biome
    corepack
    rustywind
    pnpm-shell-completion

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

    hurl
    curl
    beautysh
    shellcheck
    bash-language-server

    gcc
    rustc
    cargo
    clippy
    rustup
    rustfmt

    zls
    zig
    zig-shell-completions

    tinymist
    typstyle
    typst

    qsv
    miller
    csvdiff
    csvlens

    just
    cmake
    ninja
    gnumake
    pkg-config

    nil
    sleek
    tree-sitter
    glsl_analyzer
    nixfmt-classic
    yaml-language-server
  ];
}
