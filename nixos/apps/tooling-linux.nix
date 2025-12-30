{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    tailwindcss_4
    watchman

    kdePackages.qt6ct
    kdePackages.qtbase
    kdePackages.qttools
    kdePackages.qtdeclarative

    # needed for winboat
    freerdp
    docker_28
    docker-compose

    libcxx.dev
    stdenv.cc.cc.lib
    stdenv.cc
    stdenv
    zlib
  ];

  # compiling flags needed for nixos
  environment.sessionVariables = {
    AR = "${pkgs.stdenv.cc.bintools}/bin/ar";
    CC = "${pkgs.stdenv.cc}/bin/gcc";
    CXXFLAGS = "-O2 -D_GNU_SOURCE";
    CFLAGS = "-O2 -D_GNU_SOURCE";

    PYTHONPATH =
      "${config.internal.pythonWithTk}/${config.internal.pythonWithTk.sitePackages}";
    TCL_LIBRARY = "${pkgs.tcl}/lib/tcl${pkgs.tcl.version}";
    TK_LIBRARY = "${pkgs.tk}/lib/tk${pkgs.tk.version}";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  users.extraGroups.docker.members = [ "and-rs" ];
  virtualisation.docker = {
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
