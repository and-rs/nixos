{ pkgs, inputs, ... }:
let
  stablePkgs = inputs.stable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in { nixpkgs.overlays = [ (final: prev: { bun = stablePkgs.bun; }) ]; }
