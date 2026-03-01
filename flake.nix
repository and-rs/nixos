{
  description = "and-rs flake (NixOS + nix-darwin)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-25.11";

    nufmt = {
      url = "github:nushell/nufmt";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xremap = {
      url = "github:xremap/nix-flake";
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

  outputs =
    {
      self,
      nufmt,
      xremap,
      stable,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }@inputs:
    let
      linuxSystem = "x86_64-linux";
      darwinSystem = "aarch64-darwin";

      packagesOverlayNixos = final: prev: {
        ly = stable.legacyPackages.${linuxSystem}.ly;
        corepack = stable.legacyPackages.${linuxSystem}.corepack;

        nufmt = nufmt.packages.${final.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
          patches = [ ];
          doCheck = false;
        });

        helium-browser = final.callPackage ./nixos/apps/helium.nix { };
        docker-compose = stable.legacyPackages.${linuxSystem}.docker-compose;

        obs-backgroundremoval = final.callPackage ./nixos/apps/obs-backgroundremoval.nix {
          onnxruntime = final.onnxruntime.override { cudaSupport = true; };
        };

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
      mkDevShell =
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        pkgs.mkShell {
          packages = with pkgs; [
            terraform
            awscli2
            just
          ];
          shellHook = ''
            export REGION="us-west-2"
            export TF_VAR_target_region="$REGION"
            export AWS_DEFAULT_REGION="$REGION"
            export AWS_REGION="$REGION"
            aws configure set profile.nix-dev.region "$REGION"
            aws configure set profile.nix-dev.credential_process \
              "aws configure export-credentials --profile default --format process"
            export AWS_PROFILE="nix-dev"
          '';
        };
    in
    {
      devShells.${linuxSystem}.default = mkDevShell linuxSystem;
      devShells.${darwinSystem}.default = mkDevShell darwinSystem;

      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        system = linuxSystem;
        specialArgs = { inherit inputs linuxSystem; };

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
