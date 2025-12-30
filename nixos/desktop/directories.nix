{ ... }:
let
  home = "/home/and-rs";
  username = "and-rs";
in {
  systemd.tmpfiles.rules = [
    "d ${home}/Pictures       0755 ${username} users -"
    "d ${home}/Vault          0755 ${username} users -"
    "d ${home}/Vault/dev      0755 ${username} users -"
    "d ${home}/Vault/work     0755 ${username} users -"
    "d ${home}/Vault/personal 0755 ${username} users -"
  ];
}
