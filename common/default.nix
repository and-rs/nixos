{
  imports = [
    ../common/terminal.nix
    ../common/tooling.nix
    ../common/python.nix
  ];

  nix.settings.warn-dirty = false;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    download-buffer-size = 1 * 1024 * 1024 * 1024;
    auto-optimise-store = true;

    substituters = [
      "https://cache.nixos.org"
      "s3://nixed-build-cache-bucket?region=us-west-2&priority=10"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "and-rs-nix-cache:iWAJpETVyVBzuZ4nNKQtSnWv3upzjobkgw/1IGnFu4A="
    ];
  };
}
