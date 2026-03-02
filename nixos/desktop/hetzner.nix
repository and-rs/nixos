{ pkgs, ... }:
{
  systemd.user.services.rclone-hetzner = {
    description = "Mount Hetzner with rclone";
    after = [ "network-online.target" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/Hetzner";
      ExecStart = "${pkgs.rclone}/bin/rclone mount --vfs-cache-mode=writes hetzner: %h/Hetzner";
      ExecStop = "/run/wrappers/bin/fusermount -u %h/Hetzner";
      Restart = "always";
      RestartSec = "10s";
      Environment = [ "PATH=/run/wrappers/bin" ];
    };
  };
}
