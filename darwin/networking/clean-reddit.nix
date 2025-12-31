 { pkgs, ... }:
let
  redditBlocker = "${pkgs.writeTextDir "reddit-blocker.py" (builtins.readFile ../scripts/reddit-blocker.py)}";
  proxyPac = pkgs.writeText "proxy.pac" (builtins.readFile ../scripts/proxy.pac);
  certPath = "/tmp/mitmproxy-ca-cert.pem";
in {
  environment.systemPackages = [ pkgs.mitmproxy ];

  launchd.daemons.mitmproxy = {
    script =
      "${pkgs.mitmproxy}/bin/mitmweb -s ${redditBlocker}/reddit-blocker.py --listen-port 8080 --no-web-open-browser --set block_global=false";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/var/log/mitmproxy.log";
      StandardErrorPath = "/var/log/mitmproxy.log";
    };
  };

  system.activationScripts.postActivation.text = ''
    echo "Configuring Reddit Clean Proxy..."

    # 1. Certificate Setup
    echo "Checking mitmproxy CA certificate..."
    if ! security find-certificate -c "mitmproxy" /Library/Keychains/System.keychain > /dev/null 2>&1; then
      echo "Downloading mitmproxy CA certificate..."
      curl -s -o ${certPath} https://mitm.it/cert/mitmproxy-ca-cert.pem

      # Robust check for valid certificate content using grep directly on file
      if grep -q "BEGIN CERTIFICATE" ${certPath} 2>/dev/null; then
        echo "Installing mitmproxy CA certificate..."
        security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ${certPath}
        echo "mitmproxy CA certificate installed successfully"
      else
        echo "WARNING: Failed to download valid mitmproxy CA certificate. HTTPS interception will fail."
        # Don't fail the build, just warn
      fi
      rm -f ${certPath}
    else
      echo "mitmproxy CA certificate already installed"
    fi

    # 2. Configure Proxy Auto-Config (PAC) for Wi-Fi
    echo "Setting up Proxy Auto-Config..."
    networksetup -setautoproxyurl "Wi-Fi" "file://${proxyPac}"
    networksetup -setautoproxystate "Wi-Fi" on

    # Ensure other proxies are off to avoid conflicts
    networksetup -setwebproxystate "Wi-Fi" off
    networksetup -setsecurewebproxystate "Wi-Fi" off
    
    echo "Reloading mitmproxy daemon..."
    launchctl kickstart -k system/org.nixos.mitmproxy 2>/dev/null || true
  '';
}
