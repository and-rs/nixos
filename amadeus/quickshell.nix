{ pkgs }:
let
  customPam = pkgs.linux-pam.overrideAttrs (_: {
    postPatch = ''
      substituteInPlace modules/module-meson.build \
        --replace-fail "sbindir / 'unix_chkpwd'" "'/usr/sbin/unix_chkpwd'"
    '';
  });
in
pkgs.quickshell.override {
  pam = customPam;
}
