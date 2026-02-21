{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:
let
  pname = "zshellcheck";
  version = "v0.1.1";

  src = fetchurl {
    url = "https://github.com/afadesigns/zshellcheck/releases/download/${version}/zshellcheck_Linux_x86_64.tar.gz";
    hash = "sha256-xy+noaT9b6y7Sztz1TWNLH6vLQ3nfnFpqJ9tHHx5BM0=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ autoPatchelfHook ];

  sourceRoot = ".";

  installPhase = ''
    install -Dm755 zshellcheck $out/bin/zshellcheck
  '';

  meta = {
    description = "Static analysis for Zsh ecosystem";
    homepage = "https://github.com/afadesigns/zshellcheck";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "zshellcheck";
  };
}
