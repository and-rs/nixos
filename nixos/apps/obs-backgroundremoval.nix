{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  obs-studio,
  onnxruntime,
  opencv,
  qt6,
  curl,
}:

stdenv.mkDerivation rec {
  pname = "obs-backgroundremoval";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "royshil";
    repo = "obs-backgroundremoval";
    rev = version;
    hash = "sha256-bl0KixfBnBeyidZ4+RJhX4TDy33l9awo0wISMr7XUwk=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    onnxruntime
    obs-studio
    qt6.qtbase
    curl.dev
    opencv
  ];

  dontWrapQtApps = true;

  meta = {
    description = "OBS plugin to replace the background in portrait images and video";
    homepage = "https://github.com/royshil/obs-backgroundremoval";
    license = lib.licenses.mit;
    inherit (obs-studio.meta) platforms;
  };
}
