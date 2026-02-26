{ pkgs, ... }:
let
  dnsBypassProxy = pkgs.writeScript "yt-dlp-wrapper.py" ''
    import socket
    import select
    import subprocess
    import sys
    import threading

    DNS_TARGET = "8.8.8.8"
    BIND_HOST = "127.0.0.1"

    def get_ip(host: str) -> str:
        cmd = [
            "${pkgs.dnsutils}/bin/dig",
            f"@{DNS_TARGET}",
            host,
            "+short",
            "A"
        ]
        output = subprocess.check_output(cmd).decode().strip()
        lines = [l for l in output.split('\n') if l]
        return lines[-1] if lines else ""

    def handle(client: socket.socket):
        try:
            req = client.recv(4096)
            if not req.startswith(b'CONNECT'):
                return

            url = req.split(b'\n')[0].split(b' ')[1]
            host, port_bytes = url.split(b':')
            target_ip = get_ip(host.decode())

            remote = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            remote.connect((target_ip, int(port_bytes)))
            client.sendall(b'HTTP/1.1 200 Connection Established\r\n\r\n')

            socks = [client, remote]
            while True:
                r, _, _ = select.select(socks, [], [])
                if client in r:
                    data = client.recv(32768)
                    if not data: break
                    remote.sendall(data)
                if remote in r:
                    data = remote.recv(32768)
                    if not data: break
                    client.sendall(data)
        except Exception:
            pass
        finally:
            client.close()
            try: remote.close()
            except Exception: pass

    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind((BIND_HOST, 0))
    s.listen(10)

    port = s.getsockname()[1]

    def run_proxy():
        while True:
            c, _ = s.accept()
            threading.Thread(target=handle, args=(c,), daemon=True).start()

    threading.Thread(target=run_proxy, daemon=True).start()

    sys.exit(
        subprocess.run(
            ["${pkgs.yt-dlp}/bin/yt-dlp", f"--proxy=http://127.0.0.1:{port}"]
            + sys.argv[1:]
        ).returncode
    )
  '';
in
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "yt-dlp" ''
      exec ${pkgs.python3}/bin/python3 ${dnsBypassProxy} "$@"
    '')
  ];
}
