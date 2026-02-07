{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bun
    deno
    biome
    corepack
    nodejs_25
    rustywind
    pnpm-shell-completion

    vtsls
    typescript
    nodePackages_latest.eslint
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
    rustfmt
    rust-analyzer

    marksman
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

    buf
    nil
    sleek
    nixfmt
    kdlfmt
    tree-sitter
    glsl_analyzer
    yaml-language-server

    # I use zig tooling from source
    zig-shell-completions
  ];
}
