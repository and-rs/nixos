{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    rclone
    file
    glab
    bc
  ];
}
