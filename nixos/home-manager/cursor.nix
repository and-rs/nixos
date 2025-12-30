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
  home.packages = with pkgs; [ apple-cursor ];
  home.pointerCursor = {
    name = "'Posy's Cursor Black (Scalable)'";
    package = posysCursor;
    gtk.enable = true;
    size = 20;
  };
}
