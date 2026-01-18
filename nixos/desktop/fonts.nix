{ pkgs, ... }:
{
  nixpkgs.config.input-fonts.acceptLicense = true;

  fonts = {
    packages = with pkgs; [
      hanken-grotesk # UI
      adwaita-fonts
      input-fonts
      commit-mono
      recursive
    ];
    fontconfig = {
      enable = true;
      antialias = true;
      subpixel.lcdfilter = "none";
      hinting = {
        enable = true;
        autohint = false;
        style = "full";
      };
      defaultFonts = {
        monospace = [ "Input Mono" ];
        sansSerif = [ "Hanken Grotesk" ];
        serif = [ "Hanken Grotesk" ];
      };
    };
  };
}
