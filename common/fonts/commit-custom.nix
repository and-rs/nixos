{
  stdenv,
  fontsPath,
}:
stdenv.mkDerivation {
  name = "commit-custom";
  src = fontsPath;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp -v *.otf $out/share/fonts/truetype/
  '';

  meta = {
    description = "Commit Mono Font";
  };
}
