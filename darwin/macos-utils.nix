{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [ nerd-fonts.symbols-only ];
  };
  environment.systemPackages = with pkgs; [
    ffmpeg
    neovim
    aerospace
    karabiner-elements
  ];
}
