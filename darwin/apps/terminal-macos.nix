{ pkgs, ... }: {
  fonts = { packages = with pkgs; [ nerd-fonts.symbols-only ]; };
  environment.systemPackages = with pkgs; [
    # aerospace
    ffmpeg_6-full
    neovim
    skhd
  ];
}
