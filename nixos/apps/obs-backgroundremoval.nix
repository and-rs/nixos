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
  cudaPackages,
}:

let
  onnxruntimeWithTensorRT = (onnxruntime.override { cudaSupport = true; }).overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [ cudaPackages.tensorrt ];
    cmakeFlags = old.cmakeFlags ++ [
      (lib.cmakeBool "onnxruntime_USE_TENSORRT" true)
      (lib.cmakeBool "onnxruntime_USE_TENSORRT_BUILTIN_PARSER" true)
    ];
  });
in
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
    onnxruntimeWithTensorRT
    obs-studio
    qt6.qtbase
    curl.dev
    opencv
    cudaPackages.tensorrt
  ];

  dontWrapQtApps = true;

  meta = {
    description = "OBS plugin to replace the background in portrait images and video";
    homepage = "https://github.com/royshil/obs-backgroundremoval";
    license = lib.licenses.mit;
    inherit (obs-studio.meta) platforms;
  };
}
