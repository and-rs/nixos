{
  description = "Unified user tools profile";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixgl.url = "github:nix-community/nixGL";
  };

  outputs = { self, nixpkgs, nixgl }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ nixgl.overlay ];
      config.allowUnfree = true;
    };

    # Override linux-pam to use system unix_chkpwd instead of NixOS wrapper path.
    # Nix's pam_unix.so hardcodes /run/wrappers/bin/unix_chkpwd (NixOS-only).
    # On Ubuntu, the setgid-shadow binary lives at /usr/sbin/unix_chkpwd.
    customPam = pkgs.linux-pam.overrideAttrs (old: {
      postPatch = ''
        substituteInPlace modules/module-meson.build \
          --replace-fail "sbindir / 'unix_chkpwd'" "'/usr/sbin/unix_chkpwd'"
      '';
    });

    customQuickshell = pkgs.quickshell.override {
      pam = customPam;
    };

  in {
    packages.${system}.default =
      pkgs.symlinkJoin {
        name = "user-tools";

        paths = [
          (pkgs.azure-cli.override {
             withExtensions = [ pkgs.azure-cli-extensions.azure-devops ];
          })
          (pkgs.rofi.override { plugins = [ pkgs.rofi-calc ]; })

          pkgs.nushell
          pkgs.topiary
          pkgs.carapace
          pkgs.oh-my-posh

          pkgs.gh
          pkgs.tig
          pkgs.delta
          pkgs.lazygit
          pkgs.jujutsu
          pkgs.difftastic

          pkgs.fd
          pkgs.bun
          pkgs.fzf
          pkgs.btop
          pkgs.grit
          pkgs.yazi
          pkgs.clang
          pkgs.zoxide
          pkgs.dotbot
          pkgs.ripgrep
          pkgs.bob-nvim
          pkgs.tree-sitter

          pkgs.snowflake-cli
          pkgs.terraform

          pkgs.awww
          pkgs.niri
          pkgs.grim
          pkgs.satty
          pkgs.xremap
          pkgs.hypridle
          customQuickshell
          pkgs.google-chrome
          pkgs.xwayland-satellite
          pkgs.kdePackages.qtdeclarative
          pkgs.xdg-desktop-portal-gnome
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal

          pkgs.kitty
          pkgs.ghostty
          pkgs.alacritty

          pkgs.zig
          pkgs.zls

          pkgs.lua-language-server
          pkgs.yaml-language-server
          pkgs.deno

          pkgs.uv
          pkgs.ty
          pkgs.ruff
          pkgs.shfmt
          pkgs.sqlfluff

          (pkgs.nixgl.nixGLCommon pkgs.nixgl.nixGLMesa)
        ];
      };
  };
}
