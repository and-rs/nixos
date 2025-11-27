{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ghostty
    rclone
    broot
    file
    tldr
    glab
    bc
  ];
}
