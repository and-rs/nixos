{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      hanken-grotesk # UI
      adwaita-fonts

      monaspace
      recursive
      maple-mono.NL-TTF
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
        monospace = [ "CommitMono" ];
        sansSerif = [ "Hanken Grotesk" ];
        serif = [ "Hanken Grotesk" ];
      };
    };
  };
}
