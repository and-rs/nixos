{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [ nerd-fonts.symbols-only ];
  };
  environment.systemPackages = with pkgs; [
    rclone
    ffmpeg
    neovim
    aerospace
  ];
}
