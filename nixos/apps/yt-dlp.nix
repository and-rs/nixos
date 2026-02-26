{ pkgs, ... }: {
  # yt-dlp setup to override my network block
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "yt-dlp" ''
      set -e
      REAL_RESOLV=$(${pkgs.coreutils}/bin/readlink -f /etc/resolv.conf)
      DNS_FILE=$(mktemp)
      echo "nameserver 1.1.1.1" > "$DNS_FILE"
      echo "nameserver 8.8.8.8" >> "$DNS_FILE"
      trap "rm -f $DNS_FILE" EXIT
      echo "Bypassing DNS (Target: $REAL_RESOLV, Masking: nscd)..."
      exec ${pkgs.bubblewrap}/bin/bwrap \
      --dev-bind / / \
      --bind "$DNS_FILE" "$REAL_RESOLV" \
      --tmpfs /run/nscd \
      -- ${pkgs.yt-dlp}/bin/yt-dlp "$@"
    '')
  ];
}
