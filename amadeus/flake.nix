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

          pkgs.bun
          pkgs.delta
          pkgs.ripgrep
          pkgs.fzf
          pkgs.bat
          pkgs.tree-sitter
          pkgs.yazi
          pkgs.dotbot
          pkgs.clang
          pkgs.zoxide
          pkgs.oh-my-posh
          pkgs.carapace
          pkgs.yaml-language-server

          pkgs.bob-nvim
          pkgs.lua-language-server

          pkgs.gh
          pkgs.fd

          pkgs.snowflake-cli
          pkgs.terraform

          pkgs.google-chrome
          pkgs.awww
          pkgs.niri
          pkgs.xwayland-satellite
          pkgs.xdg-desktop-portal-gnome
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal

          pkgs.alacritty
          pkgs.ghostty

          pkgs.kdePackages.qtdeclarative
          customQuickshell
          pkgs.xremap
          pkgs.btop
          pkgs.hypridle

          pkgs.zig
          pkgs.zls

          pkgs.uv
          pkgs.ty
          pkgs.shfmt

          (pkgs.nixgl.nixGLCommon pkgs.nixgl.nixGLMesa)
        ];
      };
  };
}
