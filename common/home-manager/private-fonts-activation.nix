{
  config,
  lib,
  pkgs,
  isLinux,
  ...
}:
let
  privateFonts = import ../private-fonts.nix { inherit pkgs; };
  identity = "${config.home.homeDirectory}/.ssh/${if isLinux then "agenix" else "agenix-darwin"}";
in
{
  fonts.fontconfig.enable = lib.mkIf isLinux true;

  home.packages = [ privateFonts ];

  home.activation.syncPrivateFonts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${privateFonts}/bin/private-fonts-sync --identity ${lib.escapeShellArg identity}
  '';
}
