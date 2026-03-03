{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "yt-dlp" ''
      port=$(python3 -c "import socket; s=socket.socket(); s.bind((\"\",0)); print(s.getsockname()[1]); s.close()")

      ${pkgs.gost}/bin/gost -L "http://:$port?resolver=8.8.8.8" >/dev/null 2>&1 &
      proxy_pid=$!
      trap 'kill "$proxy_pid" 2>/dev/null' EXIT INT TERM

      for i in $(seq 10); do
        ${pkgs.curl}/bin/curl -s --max-time 0.2 \
          "http://127.0.0.1:$port" >/dev/null 2>&1 && break
        sleep 0.1
      done

      ${pkgs.yt-dlp}/bin/yt-dlp --proxy "http://127.0.0.1:$port" "$@"
    '')
  ];
}
