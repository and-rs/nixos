{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bun
    deno
    biome
    corepack
    rustywind
    pnpm-shell-completion

    vtsls
    typescript
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
    shfmt
    beautysh
    shellcheck
    bash-language-server

    marksman
    tinymist
    typstyle
    typst

    qsv
    miller
    csvdiff
    csvlens

    gcc
    just
    cmake
    ninja
    gnumake
    pkg-config
    rustup

    buf
    nil
    sleek
    nixfmt
    kdlfmt
    ast-grep
    tree-sitter
    glsl_analyzer

    yamlfmt
    yaml-language-server

    zig-shell-completions
  ];
}
