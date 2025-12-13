{
  description = "and-rs flake (NixOS + nix-darwin)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-25.11";

    xremap.url = "github:xremap/nix-flake";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    opencode.url = "github:aodhanhayter/opencode-flake";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, stable, xremap, zen-browser, spicetify-nix
    , home-manager, nix-darwin, nix-cachyos-kernel, ... }@inputs:
    let
      linuxSystem = "x86_64-linux";
      darwinSystem = "aarch64-darwin";
    in {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        system = linuxSystem;
        specialArgs = {
          inherit inputs linuxSystem spicetify-nix;
          cachyosOverlay = nix-cachyos-kernel.overlays.default;
        };

        modules = [
          ./common/default.nix
          ./nixos/configuration.nix
          xremap.nixosModules.default
        ];
      };

      darwinConfigurations.M1 = nix-darwin.lib.darwinSystem {
        system = darwinSystem;
        modules = [ ./darwin/configuration.nix ./common/default.nix ];
      };
    };
}
