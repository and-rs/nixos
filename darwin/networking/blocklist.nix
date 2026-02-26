{ pkgs, ... }:
let
  dnsmasqConf = pkgs.writeText "dnsmasq.conf" ''
    listen-address=127.0.0.1
    port=53
    server=1.1.1.3
    addn-hosts=/opt/blocklist.hosts
  '';

  dnsmasqWrapper = pkgs.writeShellScript "dnsmasq-wrapper" ''
    exec ${pkgs.dnsmasq}/bin/dnsmasq -k -C ${dnsmasqConf}
  '';
in
{
  environment.systemPackages = [ pkgs.dnsmasq ];

  networking.dns = [
    "127.0.0.1"
  ];

  networking.knownNetworkServices = [
    "Wi-Fi"
    "Thunderbolt Ethernet"
    "USB 10/100/1000 LAN"
  ];

  launchd.daemons.dnsmasq = {
    script = "${dnsmasqWrapper}";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      StandardErrorPath = "/var/log/dnsmasq.log";
    };
  };

  system.activationScripts.postActivation.text = ''
    echo "Reloading dnsmasq..."
    /bin/launchctl kickstart -k system/org.nixos.dnsmasq
  '';
}
