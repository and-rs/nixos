{
  config,
  lib,
  pkgs,
  isLinux,
  ...
}:
let
  cfg = config.privateFonts;
  privateFonts = import ../private-fonts.nix { inherit pkgs; };
  identity = "${config.home.homeDirectory}/.ssh/${if isLinux then "agenix" else "agenix-darwin"}";
  fontRoot =
    if isLinux then
      "${config.home.homeDirectory}/.local/share/fonts/PrivateFonts"
    else
      "${config.home.homeDirectory}/Library/Fonts/PrivateFonts";
in
{
  options.privateFonts.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Deploy the repository's private fonts.";
  };

  config = {
    fonts.fontconfig.enable = lib.mkIf isLinux true;

    home.packages = lib.mkIf cfg.enable [ privateFonts ];

    home.activation.syncPrivateFonts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${
        if cfg.enable then
          ''
            ${privateFonts}/bin/private-fonts-sync \
              --identity ${lib.escapeShellArg identity} \
              --font-root ${lib.escapeShellArg fontRoot}
          ''
        else
          ''
            rm -rf -- ${lib.escapeShellArg fontRoot}
            ${lib.optionalString isLinux "${pkgs.fontconfig}/bin/fc-cache --force"}
          ''
      }
    '';
  };
}
