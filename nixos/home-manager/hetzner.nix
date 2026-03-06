{ config, pkgs, ... }:
{
  age.identityPaths = [ "${config.home.homeDirectory}/.ssh/agenix" ];

  age.secrets.hetzner-pass = {
    file = ../../secrets/hetzner-pass.age;
  };

  programs.rclone = {
    enable = true;
    remotes.hetzner = {
      config = {
        type = "webdav";
        url = "https://u555854.your-storagebox.de";
        vendor = "other";
        user = "u555854";
      };
      secrets.pass = config.age.secrets.hetzner-pass.path;
    };
  };

  systemd.user.services.rclone-hetzner = {
    Unit = {
      Description = "Mount Hetzner with rclone";
      After = [
        "network-online.target"
        "rclone-config.service"
      ];
      Requires = [ "rclone-config.service" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      Type = "notify";
      Environment = [ "PATH=/run/wrappers/bin:/run/current-system/sw/bin" ];
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/Mounts/Hetzner";
      ExecStart = "${pkgs.rclone}/bin/rclone mount --vfs-cache-mode=full --dir-cache-time=72h --vfs-read-chunk-size=16M --vfs-read-chunk-size-limit=2G --timeout=15s --contimeout=10s --low-level-retries=1 --retries=1 hetzner: %h/Mounts/Hetzner";
      ExecStop = "/run/wrappers/bin/fusermount3 -u %h/Mounts/Hetzner";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
}
