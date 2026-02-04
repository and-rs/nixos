{
  lib,
  fetchurl,
  appimageTools,
  makeDesktopItem,
}:
let
  pname = "helium-browser";
  version = "0.8.4.1";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = "sha256-y4KzR+pkBUuyVU+ALrzdY0n2rnTB7lTN2ZmVSzag5vE=";
  };

  desktopItem = makeDesktopItem {
    name = "helium";
    icon = "helium";
    type = "Application";
    exec = "env TZ=America/Bogota helium-browser %u";
    desktopName = "Helium Browser";
    categories = [
      "Network"
      "WebBrowser"
    ];
    comment = "A fast and lightweight web browser";
    terminal = false;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${desktopItem}/share/applications/helium.desktop $out/share/applications/helium.desktop
    substituteInPlace $out/share/applications/helium.desktop \
      --replace "Exec=helium-browser" "Exec=$out/bin/helium-browser"
  '';

  meta = with lib; {
    description = "A fast and lightweight web browser";
    homepage = "https://github.com/imputnet/helium";
    license = licenses.gpl3Plus;
    mainProgram = "helium-browser";
    platforms = [ "x86_64-linux" ];
  };
}
