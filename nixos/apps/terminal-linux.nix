{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ghostty
    rclone
    broot
    file
    glab
    bc
  ];
}
