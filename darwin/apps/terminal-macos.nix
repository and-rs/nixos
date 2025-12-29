{ pkgs, ... }: {
  fonts = { packages = with pkgs; [ nerd-fonts.symbols-only ]; };
  environment.systemPackages = with pkgs; [ ffmpeg_6-full neovim aerospace ];
}
