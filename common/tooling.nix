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
    shfmt
    beautysh
    shellcheck
    bash-language-server

    gcc
    # rustc
    # cargo
    # clippy
    # rustfmt
    # rust-analyzer

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
    ast-grep
    tree-sitter
    glsl_analyzer

    yamlfmt
    yaml-language-server

    opam
    ocaml
    dune_3
    ocamlPackages.merlin
    ocamlPackages.findlib
    ocamlPackages.ocaml-lsp
    ocamlPackages.ocamlformat

    # I use zig tooling from source
    zig-shell-completions
  ];
}
