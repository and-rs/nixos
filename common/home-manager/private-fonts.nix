{
  config,
  lib,
  pkgs,
  isLinux,
  ...
}:
let
  fontRoot =
    if isLinux then
      "${config.home.homeDirectory}/.local/share/fonts/PrivateFonts"
    else
      "${config.home.homeDirectory}/Library/Fonts/PrivateFonts";

  archives = {
    commit-font = {
      file = ../../secrets/fonts/commit-font.tar.gz.age;
      installDir = "commit-font";
    };
    hermit-font = {
      file = ../../secrets/fonts/hermit-font.tar.gz.age;
      installDir = "hermit-font";
    };
    input-font = {
      file = ../../secrets/fonts/input-font.tar.gz.age;
      installDir = "input-font";
    };
    lucide-icons = {
      file = ../../secrets/fonts/lucide-icons.tar.gz.age;
      installDir = "lucide-icons";
    };
    phosphor-icons = {
      file = ../../secrets/fonts/phosphor-icons.tar.gz.age;
      installDir = "phosphor-icons";
    };
    ocrx-font-otf = {
      file = ../../secrets/fonts/ocrx-font-otf.tar.gz.age;
      installDir = "ocrx-font-otf";
    };
    ocrx-font-ttf = {
      file = ../../secrets/fonts/ocrx-font-ttf.tar.gz.age;
      installDir = "ocrx-font-ttf";
    };
  };

  extractCommands = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: spec: ''
      rm -rf "${fontRoot}/${spec.installDir}"
      mkdir -p "${fontRoot}/${spec.installDir}"
      ${pkgs.gnutar}/bin/tar \
        -xzf "${(lib.getAttr name config.age.secrets).path}" \
        -C "${fontRoot}/${spec.installDir}" \
        --strip-components=1
    '') archives
  );
in
{
  age.secrets = lib.mapAttrs (name: spec: { inherit (spec) file; }) archives;

  age.identityPaths = [
    "${config.home.homeDirectory}/.ssh/${if !isLinux then "agenix-darwin" else "agenix"}"
  ];

  fonts.fontconfig.enable = lib.mkIf isLinux true;

  home.activation = lib.mkIf (!isLinux) {
    extractPrivateFonts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${fontRoot}"
      ${extractCommands}
    '';
  };

  systemd.user.services.extract-private-fonts = lib.mkIf isLinux {
    Unit = {
      Description = "Extract Private Fonts";
      Requires = [ "agenix.service" ];
      After = [ "agenix.service" ];
      PartOf = [ "agenix.service" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "extract-fonts" ''
        set -euo pipefail
        mkdir -p "${fontRoot}"
        ${extractCommands}
        ${pkgs.fontconfig}/bin/fc-cache -f "${fontRoot}"
      '';
      RemainAfterExit = true;
    };
  };
}
