{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      hanken-grotesk # UI
      adwaita-fonts

      phosphor-custom
      lucide-custom
      commit-custom
      input-custom

      monaspace
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
        monospace = [ "CommitMono" ];
        sansSerif = [ "Hanken Grotesk" ];
        serif = [ "Hanken Grotesk" ];
      };
    };
  };
}
