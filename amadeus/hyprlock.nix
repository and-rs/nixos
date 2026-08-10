{ pkgs }:
pkgs.hyprlock.overrideAttrs (old: {
  nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.patchelf ];

  postPatch = (old.postPatch or "") + ''
    substituteInPlace src/config/ConfigManager.cpp \
      --replace-fail 'Hyprlang::STRING{"hyprlock"}' 'Hyprlang::STRING{"login"}'
  '';

  postFixup = (old.postFixup or "") + ''
    # Use the host PAM implementation so it can load the host's PAM modules.
    patchelf --replace-needed libpam.so.0 /lib/x86_64-linux-gnu/libpam.so.0 $out/bin/hyprlock
    patchelf --force-rpath --add-rpath /lib/x86_64-linux-gnu --add-rpath /usr/lib/x86_64-linux-gnu $out/bin/hyprlock
  '';
})
