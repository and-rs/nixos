{ pkgs, ... }:

let
  ytDlpWrapper =
    if pkgs.stdenv.isLinux then
      pkgs.writeShellScriptBin "yt-dlp" ''
        set -e
        REAL_RESOLV=$(${pkgs.coreutils}/bin/readlink -f /etc/resolv.conf)
        DNS_FILE=$(mktemp)
        echo "nameserver 1.1.1.1" > "$DNS_FILE"
        echo "nameserver 8.8.8.8" >> "$DNS_FILE"
        trap "rm -f $DNS_FILE" EXIT
        exec ${pkgs.bubblewrap}/bin/bwrap \
          --dev-bind / / \
          --bind "$DNS_FILE" "$REAL_RESOLV" \
          --tmpfs /run/nscd \
          -- ${pkgs.yt-dlp}/bin/yt-dlp "$@"
      ''

    else if pkgs.stdenv.isDarwin then
      pkgs.writeShellScriptBin "yt-dlp" ''
        port=$(python3 -c "import socket; s=socket.socket(); s.bind((\"\",0)); print(s.getsockname()[1]); s.close()")

        ${pkgs.gost}/bin/gost -L "http://:$port?resolver=8.8.8.8" >/dev/null 2>&1 &
        proxy_pid=$!
        trap 'kill "$proxy_pid" 2>/dev/null' EXIT INT TERM

        for i in $(seq 10); do
          ${pkgs.curl}/bin/curl -s --max-time 0.2 \
            "http://127.0.0.1:$port" >/dev/null 2>&1 && break
          sleep 0.1
        done

        exec ${pkgs.yt-dlp}/bin/yt-dlp \
          --proxy "http://127.0.0.1:$port" "$@"
      ''
    else
      throw "unsupported platform";
in
{
  environment.systemPackages = [ ytDlpWrapper ];
}
