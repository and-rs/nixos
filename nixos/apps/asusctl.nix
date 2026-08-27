{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  systemd,
  coreutils,
  gnugrep,
  pkg-config,
  fontconfig,
  libGL,
  libinput,
  libxkbcommon,
  libgbm,
  seatd,
  wayland,
  udevCheckHook,
}:

let
  version = "6.4.0";
  src = fetchFromGitHub {
    owner = "OpenGamingCollective";
    repo = "asusctl";
    # Pin the commit instead of a retaggable GitHub release tag.
    rev = "e6c1469ccf2a745c6a1aff763852df90066c6baa";
    hash = "sha256-qLdOdZaQm3t7LhvoCCo/FwZo4O7Z9aP1KPPlERgZX00=";
  };
in
rustPlatform.buildRustPackage {
  pname = "asusctl";
  inherit version src;
  cargoHash = "sha256-sAJ4el6URZXHD2NWiWpJSBf8Qeq2v/y+F9KpMCc8BbE=";

  postPatch = ''
    substituteInPlace data/asusd.service \
      --replace-fail /usr/bin/asusd $out/bin/asusd \
      --replace-fail /bin/sleep ${lib.getExe' coreutils "sleep"}
    substituteInPlace data/asus-shutdown.service \
      --replace-fail /usr/bin/asus-shutdown $out/bin/asus-shutdown
    substituteInPlace Makefile \
      --replace-fail /usr/bin/grep ${lib.getExe gnugrep}
  '';

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    udevCheckHook
  ];

  buildInputs = [
    fontconfig
    libGL
    libinput
    libxkbcommon
    libgbm
    seatd
    systemd
    wayland
  ];

  cargoBuildFlags = [
    "--package"
    "asusctl"
    "--package"
    "asusd"
    "--package"
    "asus-shutdown"
  ];

  env.RUSTFLAGS = toString (
    map (arg: "-C link-arg=${arg}") [
      "-Wl,--push-state,--no-as-needed"
      "-lEGL"
      "-lfontconfig"
      "-lwayland-client"
      "-Wl,--pop-state"
    ]
  );

  postInstall = ''
    install -Dm755 target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/asusctl -t $out/bin
    install -Dm755 target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/asusd -t $out/bin
    install -Dm755 target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/asus-shutdown -t $out/bin
    install -Dm644 data/asusd.rules $out/lib/udev/rules.d/99-asusd.rules
    install -Dm644 rog-aura/data/aura_support.ron $out/share/asusd/aura_support.ron
    install -Dm644 data/asusd.conf $out/share/dbus-1/system.d/asusd.conf
    install -Dm644 data/asusd.service $out/lib/systemd/system/asusd.service
    install -Dm644 data/asus-shutdown.service $out/lib/systemd/system/asus-shutdown.service
    install -Dm644 LICENSE $out/share/asusctl/LICENSE
    cp -r rog-anime/data/anime $out/share/asusd/
  '';

  doCheck = false;
  doInstallCheck = true;

  meta = {
    description = "ASUS laptop control daemon and CLI";
    homepage = "https://github.com/OpenGamingCollective/asusctl";
    license = lib.licenses.mpl20;
    platforms = [ "x86_64-linux" ];
  };
}
