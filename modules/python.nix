{ pkgs, lib, config, ... }:
let
  myPython = pkgs.python313.buildEnv.override {
    extraLibs = with pkgs.python313Packages; [ tkinter pip virtualenv uv ];
    ignoreCollisions = true;
  };
in {
  options.internal.pythonWithTk = lib.mkOption {
    type = lib.types.package;
    description = "Shared Python environment with Tkinter";
  };

  config = {
    internal.pythonWithTk = myPython;

    environment.systemPackages = [
      config.internal.pythonWithTk
      pkgs.basedpyright
      pkgs.djlint
      pkgs.black
      pkgs.ruff
      pkgs.tcl
      pkgs.tk
    ];
  };
}
