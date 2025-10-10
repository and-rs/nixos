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

    python313Packages.jinja2
    python313Packages.pandas
    python313Packages.pip
    basedpyright
    virtualenv
    python313
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
