{
  description = "and-rs flake (NixOS + nix-darwin)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-23.11";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    xremap.url = "github:xremap/nix-flake";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, stable, chaotic, xremap, zen-browser, spicetify-nix
    , home-manager, nix-darwin, ... }@inputs:
    let
      linuxSystem = "x86_64-linux";
      darwinSystem = "aarch64-darwin";
    in {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        system = linuxSystem;
        specialArgs = { inherit inputs linuxSystem spicetify-nix; };
        modules = [
          ./nixos/configuration.nix
          ./nixos/settings.nix
          xremap.nixosModules.default
          chaotic.nixosModules.default
        ];
      };

      darwinConfigurations.M1 = nix-darwin.lib.darwinSystem {
        system = darwinSystem;
        modules = [ ./darwin/configuration.nix ];
      };

      # darwinPackages = self.darwinConfigurations.M1.pkgs;
    };
}
