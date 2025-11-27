{ pkgs, ... }:
let
  posysCursor = pkgs.runCommand "posys-cursor-black-scalable" { } ''
    mkdir -p $out/share/icons
    ln -s ${
      pkgs.fetchzip {
        url =
          "https://github.com/Morxemplum/posys-cursor-scalable/releases/download/v1.3/plasma_black_v1.3.tar.gz";
        sha256 = "14hhsjai1hiwdpg9ilmwrisj88kc78101vh18sx7gx98j86iw04r";
      }
    } "$out/share/icons/Posy's Cursor Black (Scalable)"
  '';
in {
  home.pointerCursor = {
    gtk.enable = true;
    # x11 = {
    #   enable = true;
    #   defaultCursor = "Posy's Cursor Black (Scalable)";
    # };
    name = "Posy's Cursor Black (Scalable)";
    size = 24;
    package = posysCursor;
  };
}
