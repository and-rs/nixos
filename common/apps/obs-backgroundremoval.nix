{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  obs-studio,
  onnxruntime,
  opencv,
  qt6,
  pkg-config,
  curl,
}:

stdenv.mkDerivation rec {
  pname = "obs-backgroundremoval";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "occ-ai";
    repo = "obs-backgroundremoval";
    rev = version;
    hash = "sha256-2BVcOH7wh1ibHZmaTMmRph/jYchHcCbq8mn9wo4LQOU=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];
  buildInputs = [
    obs-studio
    onnxruntime
    opencv.cxxdev
    qt6.qtbase
    curl
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DCMAKE_MODULE_PATH:PATH=${src}/cmake"
    "-DUSE_CUDA=ON"
    "-DENABLE_OPENCL=ON"
    "-DUSE_SYSTEM_CURL=ON"
    "-DUSE_SYSTEM_OPENCV=ON"
    "-DUSE_SYSTEM_ONNXRUNTIME=ON"
  ];

  meta = {
    description = "OBS plugin to replace the background in portrait images and video";
    homepage = "https://github.com/royshil/obs-backgroundremoval";
    license = lib.licenses.mit;
    inherit (obs-studio.meta) platforms;
  };
}
