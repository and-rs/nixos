{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    tailwindcss_4
    watchman

    kdePackages.qt6ct
    kdePackages.qtbase
    kdePackages.qttools
    kdePackages.qtdeclarative

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

    LD_LIBRARY_PATH = "${
        pkgs.lib.makeLibraryPath [
          pkgs.stdenv.cc.cc.lib
          pkgs.zlib
          pkgs.tcl
          pkgs.tk
        ]
      }:$LD_LIBRARY_PATH";
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
