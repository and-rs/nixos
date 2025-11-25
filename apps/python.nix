{ pkgs, ... }:
let
  pythonWithTk = pkgs.python313.buildEnv.override {
    extraLibs = with pkgs.python313Packages; [ tkinter pip virtualenv uv ];
    ignoreCollisions = true;
  };
  sitePackages = pkgs.python313.sitePackages;
in {
  environment.systemPackages = with pkgs; [
    zlib
    libcxx.dev
    stdenv.cc.cc.lib
    stdenv.cc
    stdenv

    pythonWithTk
    basedpyright
    djlint
    black
    ruff
    tcl
    tk
  ];

  environment.sessionVariables = {
    PYTHONPATH = "${pythonWithTk}/${sitePackages}";
    TCL_LIBRARY = "${pkgs.tcl}/lib/tcl${pkgs.tcl.version}";
    TK_LIBRARY = "${pkgs.tk}/lib/tk${pkgs.tk.version}";
    AR = "${pkgs.stdenv.cc.bintools}/bin/ar";
    CC = "${pkgs.stdenv.cc}/bin/gcc";
    CXXFLAGS = "-O2 -D_GNU_SOURCE";
    CFLAGS = "-O2 -D_GNU_SOURCE";

    LD_LIBRARY_PATH = "${
        pkgs.lib.makeLibraryPath [
          pkgs.stdenv.cc.cc.lib
          pkgs.zlib
          pkgs.tcl
          pkgs.tk
        ]
      }:$LD_LIBRARY_PATH";
  };
}
