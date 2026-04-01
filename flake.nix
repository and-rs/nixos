{
  description = "and-rs flake (NixOS + nix-darwin)";

  inputs = {
    obs-rev.url = "github:nixos/nixpkgs/2fc6539b481e1d2569f25f8799236694180c0993";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-25.11";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
      agenix,
      stable,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }@inputs:
    let
      linuxSystem = "x86_64-linux";
      darwinSystem = "aarch64-darwin";

      packagesOverlayShared = final: prev: {
        yt-dlp = stable.legacyPackages.${final.stdenv.hostPlatform.system}.yt-dlp;
        corepack = stable.legacyPackages.${final.stdenv.hostPlatform.system}.corepack;
        nufmt = nufmt.packages.${final.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
          patches = [ ];
          doCheck = false;
        });
      };

      packagesOverlayNixos = final: prev: {
        ly = stable.legacyPackages.${linuxSystem}.ly;
        docker-compose = stable.legacyPackages.${linuxSystem}.docker-compose;
        helium-browser = final.callPackage ./nixos/apps/helium.nix { };
        obs-backgroundremoval =
          let
            pkgsPinned = import inputs.obs-rev {
              system = final.stdenv.hostPlatform.system;
              config.allowUnfree = true;
            };
          in
          pkgsPinned.callPackage ./nixos/apps/obs-backgroundremoval.nix { };
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
            ssm-session-manager-plugin
            terraform
            awscli2
            just
          ];
          shellHook = ''
            export REGION="us-west-2"
            export REPO_URL="github:and-rs/nixed"

            export TF_VAR_repo_url="$REPO_URL"
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
          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [
              packagesOverlayShared
              packagesOverlayNixos
            ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              isLinux = true;
            };
            home-manager.users.and-rs = {
              imports = [ ./common/home-manager/home.nix ];
            };
          }
        ];
      };

      darwinConfigurations.M1 = nix-darwin.lib.darwinSystem {
        system = darwinSystem;
        specialArgs = { inherit inputs; };
        modules = [
          ./darwin/configuration.nix
          ./common/default.nix
          { nixpkgs.overlays = [ packagesOverlayShared ]; }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              isLinux = false;
            };
            home-manager.users.and-rs = {
              imports = [ ./common/home-manager/home.nix ];
            };
          }
        ];
      };
    };
}
