{ pkgs, ... }: {
  nixpkgs.config.input-fonts.acceptLicense = true;

  fonts = {
    packages = with pkgs; [ input-fonts recursive hanken-grotesk ];
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
