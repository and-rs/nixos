{
  lib,
  stdenv,
  fontsPath,
}:
stdenv.mkDerivation {
  name = "lucide-custom";
  src = fontsPath;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -v *.ttf $out/share/fonts/truetype/
  '';

  meta = with lib; {
    description = "Lucide fonts";
    license = licenses.unfree;
  };
}
