{ pkgs, ... }: {
  services.unbound = {
    enable = true;
    settings.server.include = "/var/lib/unbound/blocklist.conf";
  };

  systemd.tmpfiles.rules =
    [ "f /var/lib/unbound/blocklist.conf 0644 unbound unbound -" ];

  systemd.services.update-blocklist = {
    description = "Update OISD + Local Blocklist";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    path = [ pkgs.curl pkgs.gnused pkgs.gawk ];
    script = ''
      DIR="/var/lib/unbound"
      OUT="$DIR/blocklist.conf.tmp"
      FINAL="$DIR/blocklist.conf"
      PRIVATE="/home/and-rs/.blocklist.txt"

      : > "$OUT"

      curl -fL https://nsfw.oisd.nl/ | \
        sed -n 's/^||/local-zone: "/; s/\^$/" always_nxdomain/p' \
        >> "$OUT"

      if [ -f "$PRIVATE" ]; then
        printf "\n" >> "$OUT"
        awk '!/^#/ && NF { print "local-zone: \"" $NF "\" always_nxdomain" }' "$PRIVATE" \
          >> "$OUT"
      fi

      if [ -s "$OUT" ]; then
        chown unbound:unbound "$OUT"
        chmod 644 "$OUT"
        mv "$OUT" "$FINAL"
        /run/current-system/systemd/bin/systemctl reload-or-restart unbound
      else
        rm "$OUT"
      fi
    '';
  };

  systemd.timers.update-blocklist = {
    wantedBy = [ "timers.target" ];
    partOf = [ "update-blocklist.service" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
}
