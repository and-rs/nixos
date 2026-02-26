{
  description = "and-rs flake (NixOS + nix-darwin)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-25.11";

    nufmt = {
      url = "github:nushell/nufmt";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    opencode.url = "github:sst/opencode";
    xremap.url = "github:xremap/nix-flake";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nufmt, xremap, stable, nixpkgs, zen-browser, spicetify-nix
    , home-manager, nix-darwin, ... }@inputs:
    let
      linuxSystem = "x86_64-linux";
      darwinSystem = "aarch64-darwin";

      packagesOverlayNixos = final: prev: {
        ly = stable.legacyPackages.${linuxSystem}.ly;
        obs-backgroundremoval =
          final.callPackage ./common/apps/obs-backgroundremoval.nix { };
        nufmt =
          nufmt.packages.${final.stdenv.hostPlatform.system}.default.overrideAttrs
          (old: {
            patches = [ ];
            doCheck = false;
          });

        helium-browser = final.callPackage ./nixos/apps/helium.nix { };
        docker-compose = stable.legacyPackages.${linuxSystem}.docker-compose;

        phosphor-custom = final.callPackage ./common/fonts/phosphor-custom.nix {
          fontsPath = ./fonts/phosphor-icons;
        };
        lucide-custom = final.callPackage ./common/fonts/lucide-custom.nix {
          fontsPath = ./fonts/lucide-icons;
        };
        input-custom = final.callPackage ./common/fonts/input-custom.nix {
          fontsPath = ./fonts/input-font;
        };
        commit-custom = final.callPackage ./common/fonts/commit-custom.nix {
          fontsPath = ./fonts/commit-font;
        };
      };
    in {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        system = linuxSystem;
        specialArgs = { inherit inputs linuxSystem spicetify-nix; };

        modules = [
          ./common/default.nix
          ./nixos/configuration.nix
          xremap.nixosModules.default
          { nixpkgs.overlays = [ packagesOverlayNixos ]; }
        ];
      };

      darwinConfigurations.M1 = nix-darwin.lib.darwinSystem {
        system = darwinSystem;
        specialArgs = { inherit inputs; };
        modules = [
          ./darwin/configuration.nix
          ./common/default.nix
          { nixpkgs.overlays = [ packagesOverlayNixos ]; }
        ];
      };
    };
}
