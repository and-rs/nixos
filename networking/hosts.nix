{ pkgs, ... }:
let
  blocklist-raw = pkgs.fetchurl {
    url = "https://nsfw.oisd.nl/";
    sha256 = "sha256-QSbuAfJrc9yqVereG3OrfXDtN/qffM2HMW5a39lFYzQ=";
  };

  private-list = builtins.readFile "/home/and-rs/.blocklist.txt";
  blocklist-oisd = pkgs.runCommand "nsfw-blocklist" { } ''
    ${pkgs.python3}/bin/python3 << 'PYTHON' > $out
    for line in open("${blocklist-raw}").readlines():
        line = line.strip()
        if not line or line.startswith("!") or line.startswith("["):
            continue
        if line.startswith("||") and line.endswith("^"):
            domain = line[2:-1]
            print(f"127.0.0.1 {domain}")
    PYTHON
  '';

in {
  networking = {
    extraHosts = (builtins.readFile blocklist-oisd) + private-list;
    networkmanager.enable = true;
    hostName = "M16";
  };
}
