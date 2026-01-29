{
  lib,
  stdenv,
  fontsPath,
}:
stdenv.mkDerivation {
  name = "phosphor-custom";
  src = fontsPath;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -v *.ttf $out/share/fonts/truetype/
  '';

  meta = with lib; {
    description = "Phosphor fonts";
    license = licenses.unfree;
  };
}
