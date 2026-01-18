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
    rustfmt
    rust-analyzer

    zls
    zig
    zig-shell-completions

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
    tree-sitter
    glsl_analyzer
    yaml-language-server
  ];
}
