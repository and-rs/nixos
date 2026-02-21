{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ghostty
    rclone
    file
    glab
    bc
  ];
}
