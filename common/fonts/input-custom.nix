{
  lib,
  stdenv,
  fontsPath,
}:
stdenv.mkDerivation {
  name = "input-custom";
  src = fontsPath;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -v *.ttf $out/share/fonts/truetype/
  '';

  meta = with lib; {
    description = "Input fonts";
    license = licenses.unfree;
  };
}
